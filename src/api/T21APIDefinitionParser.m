//
//  T21APIDefinitionParser.m
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIErrors.h"
#import "T21APIDefinitionParser.h"
#import "DDXML.h"


static NSString * const API = @"API";
static NSString * const API_BASEURL = @"baseurl";

static NSString * const LOGGER = @"LOGGER";
static NSString * const LOGGER_SHOW = @"show";

static NSString * const SERVICE = @"SERVICE";
static NSString * const SERVICE_NAME = @"name";
static NSString * const SERVICE_URL = @"url";
static NSString * const SERVICE_VERB = @"verb";
static NSString * const SERVICE_PARENT = @"parent";
static NSString * const SERVICE_TRAITS = @"traits";
static NSString * const SERVICE_DEFAULT_PARENT = @"default";
static NSString * const SERVICE_CONTENT_TYPE = @"contentType";

static NSString * const TRAITS = @"TRAITS";
static NSString * const TRAIT = @"TRAIT";
static NSString * const TRAIT_NAME = @"name";

static NSString * const PARAM = @"PARAM";
static NSString * const PARAM_NAME = @"name";
static NSString * const PARAM_VALUE = @"value";
static NSString * const PARAM_VALUES = @"values";
static NSString * const PARAM_TYPE = @"type";
static NSString * const PARAM_MANDATORY = @"mandatory";

static NSString * const PARAM_TYPE_QUERY = @"query";
static NSString * const PARAM_TYPE_HEADER = @"header";
static NSString * const PARAM_TYPE_PATH = @"path";
static NSString * const PARAM_TYPE_BODY = @"body";


static NSString * const VERB_POST = @"POST";
static NSString * const VERB_GET = @"GET";
static NSString * const VERB_PUT = @"PUT";
static NSString * const VERB_PATCH = @"PATCH";
static NSString * const VERB_DELETE = @"DELETE";
static NSString * const VERB_OPTIONS = @"OPTIONS";
static NSString * const VERB_HEAD = @"HEAD";


@implementation T21APIDefinitionParser

#pragma mark - Get Api Definition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loggingEnabled = NO;
    }
    return self;
}

-(T21APIDefinition*)getApiDefinitionForData:(NSData*)data
{
    NSError * error;
    NSAssert(data,@"API definition file can't be loaded, data is null");
    _document = [[DDXMLDocument alloc]initWithData:data options:DDXMLDocumentXMLKind error:&error];
    NSAssert(_document,@"API definition data contains bad xml format %@",error);
    [self parse:&error];
    NSAssert(_definition && !error,@"API definition data contains bad xml format %@",error);
    return _definition;
}

-(T21APIDefinition*)getApiDefinitionForFile:(NSString*)file
{
    return [self getApiDefinitionForFile:file bundle:nil];
}

-(T21APIDefinition*)getApiDefinitionForFile:(NSString*)file bundle:(NSBundle*)bundle
{
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSURL * urlRes = [NSURL URLWithString:file];
    NSString * extension = [urlRes pathExtension];
    NSString * pathWithoutExtension = [[urlRes URLByDeletingPathExtension] absoluteString];
    NSURL * url = [bundle URLForResource:pathWithoutExtension withExtension:extension];
    NSError * error;
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSAssert(data,@"API definition file %@ cannot be found/loaded",file);
    _document = [[DDXMLDocument alloc]initWithData:data options:DDXMLDocumentXMLKind error:&error];
    NSAssert(_document,@"API definition file %@ bad xml %@",file,error);
    [self parse:&error];
    NSAssert(_definition && !error,@"API definition file %@ bad xml %@",file,error);
    return _definition;
}

#pragma mark - Parsing the XML

-(void)parse:(NSError**)error
{
    _apiDefinitionItems = [[NSMutableArray alloc] init];

    DDXMLElement * rootElement = [_document rootElement];
    [self parseElement:rootElement error:error];
    
    for (T21APIDefinition *apiDefinition in _apiDefinitionItems) {
        [apiDefinition validateApi:error];
    }
}


-(void)parseElement:(DDXMLElement*)element error:(NSError**)error
{
    if (*error == nil) {
        if (element)
        {
            //Root element - Api
            if ([element.name compare:API options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                _definition = [[T21APIDefinition alloc]init];
                NSInteger apiItemsCounter = self.apiDefinitionItems.count;
                self.apiDefinitionItems[apiItemsCounter] = _definition;
                
                for (DDXMLElement * a in [element attributes]) {
                    //Base URL
                    if ([[a name]compare:API_BASEURL options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                        if ([a stringValue]) {
                            [_definition setBaseUrl:[a stringValue]];
                        }else{
                            *error = [self createErrorBadXML];
                        }
                    }
                }
            }
            
            //Trait definitions
            if ([element.name compare:TRAIT options:NSCaseInsensitiveSearch]  == NSOrderedSame)
            {
                T21APIHTTPTrait * trait = [[T21APIHTTPTrait alloc] init];
                //Service attributes
                for (DDXMLElement * a in [element attributes]) {
                    //Name
                    if ([[a name]compare:TRAIT_NAME options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                        if ([a stringValue]) {
                            [trait setName:[a stringValue]];
                        } else {
                            if (self.loggingEnabled) {
                                NSLog(@"[API_XML] No trait name/identifier found");
                            }
                            *error = [self createErrorBadXML];
                        }
                    }
                }
                NSAssert([trait getName], @"Trait name is mandatory");
                NSAssert(![_definition getTrait:[trait getName]], @"Duplicated trait with name %@", [trait getName]);
                [_definition addTrait:trait];
                
                //Trait children (default and/or mandatory params)
                T21APIMap * mandatoryHeaders = [T21APIMap map];
                [trait setMandatoryHeaderParams:mandatoryHeaders];
                T21APIMap * defaultHeaders = [T21APIMap map];
                [trait setDefaultHeaderParams:defaultHeaders];
                
                T21APIMap * mandatoryURLParams = [T21APIMap map];
                [trait setMandatoryUrlParams:mandatoryURLParams];
                T21APIMap * defaultURLParams = [T21APIMap map];
                [trait setDefaultUrlParams:defaultURLParams];
                
                T21APIMap * mandatoryQueryParams = [T21APIMap map];
                [trait setMandatoryQueryParams:mandatoryQueryParams];
                T21APIMap * defaultQueryParams = [T21APIMap map];
                [trait setDefaultQueryParams:defaultQueryParams];
                
                // Parameters
                [self fillParametersFromNode:element
                              defaultHeaders:defaultHeaders
                            mandatoryHeaders:mandatoryHeaders
                            defaultURLParams:defaultURLParams
                          mandatoryURLParams:mandatoryURLParams
                          defaultQueryParams:defaultQueryParams
                        mandatoryQueryParams:mandatoryQueryParams];
            }
            
            //Services defintions
            if ([element.name compare:SERVICE options:NSCaseInsensitiveSearch]  == NSOrderedSame)
            {
                if (_definition) {
                    _service = [[T21APIHTTPService alloc]init];
                    [_service setBaseUrl:[_definition getBaseUrl]];
                    
                    //Service children (default and/or mandatory params)
                    T21APIMap * mandatoryHeaders = [T21APIMap map];
                    [_service setMandatoryHeaderParams:mandatoryHeaders];
                    T21APIMap * defaultHeaders = [T21APIMap map];
                    [_service setDefaultHeaderParams:defaultHeaders];
                    T21APIMap * mandatoryURLParams = [T21APIMap map];
                    [_service setMandatoryUrlParams:mandatoryURLParams];
                    T21APIMap * defaultURLParams = [T21APIMap map];
                    [_service setDefaultUrlParams:defaultURLParams];
                    T21APIMap * mandatoryQueryParams = [T21APIMap map];
                    [_service setMandatoryQueryParams:mandatoryQueryParams];
                    T21APIMap * defaultQueryParams = [T21APIMap map];
                    [_service setDefaultQueryParams:defaultQueryParams];
                    
                    //Service attributes
                    for (DDXMLElement * a in [element attributes]) {
                        //Name
                        if ([[a name]compare:SERVICE_NAME options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            if ([a stringValue]) {
                                [_service setName:[a stringValue]];
                                
                                NSAssert(![_definition getService:[_service getName]], @"Duplicated service with name %@", [_service getName]);
                                [_definition addService:_service];
                            }else{
                                if (self.loggingEnabled) {
                                    NSLog(@"[API_XML] No service name/identifier found");
                                }
                                *error = [self createErrorBadXML];
                            }
                        }
                        
                        //Parent service
                        if ([[a name]compare:SERVICE_PARENT options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            NSString * parentServiceName = [a stringValue];
                            if (parentServiceName) {
                                T21APIHTTPService * parent = [_definition getService:parentServiceName];
                                if (parent) {
                                    [_service setParent:parent];
                                }else{
                                    if (self.loggingEnabled) {
                                        NSLog(@"[API_XML] No parent service %@ found.",parentServiceName);
                                    }
                                    *error = [self createErrorBadXML];
                                }
                            }
                        }
                        
                        //Path url
                        if ([[a name]compare:SERVICE_URL options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            if ([a stringValue]) {
                                [_service setPath:[a stringValue]];
                            }
                        }
                        
                        //HTTP method
                        if ([[a name]compare:SERVICE_VERB options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            if ([a stringValue]) {
                                NSString * httpMethod = [self getHTTPMethodFromValue:[a stringValue]];
                                if (httpMethod) {
                                    [_service setHTTPMethod:httpMethod];
                                }else{
                                    *error = [self createErrorBadXML];
                                }
                            }
                        }
                        
                        //Traits
                        if ([[a name]compare:SERVICE_TRAITS options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            if ([a stringValue]) {
                                NSArray *traits = [[a stringValue] componentsSeparatedByString: @","];
                                for (NSString * name in traits) {
                                    NSString * traitName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    T21APIHTTPTrait * trait = [_definition getTrait:traitName];
                                    
                                    NSAssert(trait, @"Unknown trait with name %@", traitName);
                                    [defaultHeaders addMap:trait.getDefaultHeaderParams];
                                    [mandatoryHeaders addMap:trait.getMandatoryHeaderParams];
                                    [defaultURLParams addMap:trait.getDefaultUrlParams];
                                    [mandatoryURLParams addMap:trait.getMandatoryUrlParams];
                                    [defaultQueryParams addMap:trait.getDefaultQueryParams];
                                    [mandatoryQueryParams addMap:trait.getMandatoryQueryParams];
                                }
                            }
                        }
                    }
                    
                    // Parameters
                    [self fillParametersFromNode:element
                                  defaultHeaders:defaultHeaders
                                mandatoryHeaders:mandatoryHeaders
                                defaultURLParams:defaultURLParams
                              mandatoryURLParams:mandatoryURLParams
                              defaultQueryParams:defaultQueryParams
                            mandatoryQueryParams:mandatoryQueryParams];
                }else{
                    *error = [self createErrorBadXML];
                }
            }
            
            NSArray * elements = [element children];
            for (DDXMLElement * e in elements) {
                [self parseElement:e error:error];
            }
            
        }else{
            *error = [self createErrorBadXML];
        }
    }else{
        return;
    }
}

#pragma mark - Helper methods

-(NSString*)getHTTPMethodFromValue:(NSString*)value
{
    if ([value compare:VERB_GET options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_GET;
    } else if ([value compare:VERB_POST options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_POST;
    } else if ([value compare:VERB_PATCH options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_PATCH;
    } else if ([value compare:VERB_PUT options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_PUT;
    } else if ([value compare:VERB_DELETE options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_DELETE;
    } else if ([value compare:VERB_OPTIONS options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_OPTIONS;
    } else if ([value compare:VERB_HEAD options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return VERB_HEAD;
    } else {
        return nil;
    }
}

-(void)fillParametersFromNode:(DDXMLElement*)element
               defaultHeaders:(T21APIMap *)defaultHeaders
             mandatoryHeaders:(T21APIMap *)mandatoryHeaders
             defaultURLParams:(T21APIMap *)defaultURLParams
           mandatoryURLParams:(T21APIMap *)mandatoryURLParams
             defaultQueryParams:(T21APIMap *)defaultQueryParams
           mandatoryQueryParams:(T21APIMap *)mandatoryQueryParams

{
    for (DDXMLElement * child in [element children]) {
        if ([[child name]compare:PARAM options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString * paramType = nil;
            NSString * paramName = nil;
            NSString * paramValue = nil;
            NSArray /* NSString */ * paramValues = nil;
            BOOL mandatory = NO;
            for (DDXMLElement * paramAttr in [child attributes]) {
                
                if ([[paramAttr name]compare:PARAM_NAME options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    paramName = [paramAttr stringValue];
                }
                
                if ([[paramAttr name]compare:PARAM_TYPE options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    paramType = [paramAttr stringValue];
                }
                
                if ([[paramAttr name]compare:PARAM_VALUE options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    paramValue = [paramAttr stringValue];
                }

                if ([[paramAttr name]compare:PARAM_VALUES options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    NSArray *values = [[paramAttr stringValue] componentsSeparatedByString: @","];
                    NSMutableArray * trimmedValues = [[NSMutableArray alloc] initWithCapacity:values.count];
                    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSString * name = obj;
                        [trimmedValues addObject:[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    }];
                    paramValues = trimmedValues;
                }

                if ([[paramAttr name]compare:PARAM_MANDATORY options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    NSString * boolValueString = [paramAttr stringValue];
                    mandatory = [boolValueString boolValue];
                }
            }
            
            //check if the service is properly defined
            if (paramType != nil && paramName != nil)
            {
                NSAssert(!(paramValue != nil && paramValues != nil), @"Defined both value and values properties in parameter %@", paramName);

                T21APIMap * defaultParams;
                T21APIMap * mandatoryParams;
                if ([paramType compare:PARAM_TYPE_HEADER options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    defaultParams = defaultHeaders;
                    mandatoryParams = mandatoryHeaders;
                } else if ([paramType compare:PARAM_TYPE_PATH options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    defaultParams = defaultURLParams;
                    mandatoryParams = mandatoryURLParams;
                } else if ([paramType compare:PARAM_TYPE_QUERY options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    defaultParams = defaultQueryParams;
                    mandatoryParams = mandatoryQueryParams;
                } else {
                    // BODY
                    mandatoryParams = mandatoryQueryParams;
                }
                
                if (paramValue){
                    //default param
                    [defaultParams setObject:paramValue forKey:paramName];
                } else if (paramValues){
                    //default param
                    [defaultParams setObject:paramValues forKey:paramName];
                }
                
                if(mandatory){
                    //mandatory params
                    //Assign associated mandatory value for the 'paramName' key.
                    id mandatoryValues = paramValue ?: paramValues ?: @"";
                    [mandatoryParams setObject:mandatoryValues forKey:paramName];
                }
            }
            else
            {
                if (self.loggingEnabled) {
                    NSLog(@"[API_XML] Misconfigured parameter: name=%@, type=%@", [paramName description], [paramType description]);
                }
            }
        }
    }
}


-(NSError*)createErrorBadXML
{
    return [NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectXML userInfo:nil];
}

@end
