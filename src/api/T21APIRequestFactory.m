//
//  T21APIRequestFactory.m
//  MyPod
//
//  Created by Eloi Guzmán Cerón on 02/11/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import "T21APIRequestFactory.h"
#import "T21APIMap.h"
#import "T21APIErrors.h"
#import "NSString+URLUtils.h"
#import "NSURL+URLUtils.h"



@implementation T21APIRequestFactory

#pragma mark - Configure URLRequest

+(NSMutableURLRequest*)configureURLRequest:(NSMutableURLRequest*)urlRequest withMap:(T21APIHTTPMap*)mapHTTP errors:(NSMutableArray**)errors {
    return [self configureURLRequest:urlRequest withMap:mapHTTP errors:errors loggingEnabled:NO];
}

+(NSMutableURLRequest*)configureURLRequest:(NSMutableURLRequest*)urlRequest withMap:(T21APIHTTPMap*)mapHTTP errors:(NSMutableArray**)errors loggingEnabled:(BOOL)loggingEnabled
{
    if (!urlRequest) {
        urlRequest = [[NSMutableURLRequest alloc]init];
    }
    
    if (errors) {
        *errors = [NSMutableArray array];
    }
    
    BOOL mandatoryFieldsCorrect = YES;
    
    //Check http map
    if (!mapHTTP) {
        if (loggingEnabled) {
            NSLog(@"[Request Factory] No httpMap configured");
        }
        [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
        return nil;
    }
    
    //Set the HTTP method
    NSString * method = mapHTTP.getHTTPService.getHTTPMethod;
    //Check method
    if (!method) {
        if (loggingEnabled) {
            NSLog(@"[Request Factory] No http method configured");
        }
        [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
        return nil;
    }
    [urlRequest setHTTPMethod:method];
    
    //Check base url
    NSString * url = [mapHTTP.getHTTPService getBaseUrl];
    if (!url || url.length == 0) {
        if (loggingEnabled) {
            NSLog(@"[Request Factory] No baseUrl configured");
        }
        [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
        return nil;
    }
    
    //Check service path
    NSString * srv = mapHTTP.getHTTPService.getPath;
    if (!srv) {
        if (loggingEnabled) {
            NSLog(@"[Request Factory] No service path configured");
        }
        [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
        return nil;
    }
    
    //Add default URL params
    NSMutableDictionary * urlParams = [NSMutableDictionary dictionary];
    if (mapHTTP.getHTTPService.getDefaultUrlParams.dictionary) {
        [urlParams addEntriesFromDictionary:mapHTTP.getHTTPService.getDefaultUrlParams.dictionary];
    }
    
    //Build the URL + url params
    if (mapHTTP.getUrlParams) {
        [urlParams addEntriesFromDictionary:mapHTTP.getUrlParams.dictionary];
    }
    
    //Replace the value vars (${value_var}) using context with URL params
    if (mapHTTP.getHTTPService.getContext && urlParams.count) {
        NSError * error;
        NSDictionary * replacedURLParams = [self replaceContextParamValues:urlParams usingContext:mapHTTP.getHTTPService.getContext error:&error loggingEnabled:loggingEnabled];
        urlParams = [[NSMutableDictionary alloc]initWithDictionary:replacedURLParams];
    }
    
    //Check mandatory url params
    NSDictionary * urlMandatoryParams = mapHTTP.getHTTPService.getMandatoryUrlParams.dictionary;
    for (NSString * key in [urlMandatoryParams keyEnumerator]) {
        if ([urlParams objectForKey:key] == nil) {
            mandatoryFieldsCorrect = NO;
            if (loggingEnabled) {
                NSLog(@"[Request Factory] Mandatory URL param: %@ not found",key);
            }
        }
    }
    
    NSArray * srvComponents = [srv componentsSeparatedByString:@"/"];
    for (NSString * component in srvComponents) {
        NSString * serviceComponent = component;
        if ([serviceComponent rangeOfString:@"{"].location != NSNotFound && [serviceComponent rangeOfString:@"}"].location != NSNotFound) {
            //If component is url param
            NSString * keyParam = [serviceComponent stringByReplacingOccurrencesOfString:@"{" withString:@""];
            keyParam = [keyParam stringByReplacingOccurrencesOfString:@"}" withString:@""];
            
            serviceComponent = [urlParams objectForKey:keyParam];
            
            //check the param is correct
            if (!serviceComponent) {
                if (loggingEnabled) {
                    NSLog(@"[Request Factory] No URL param %@ defined for this service",keyParam);
                }
                [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
                return nil;
            }else if ([serviceComponent isKindOfClass:NSArray.class]) {
                // TODO: SUPPORT FOR ARRAY URL PARAMS
                // Support for URL array params is not implemented.
                // Maybe we could convert an array [@"hosts",@"srvPath1",@"srvPath2"] to @"hosts/srvPath/srvPath2"
                if (loggingEnabled) {
                    NSLog(@"[Request Factory] The defined URL param %@ is an array, the lib doesn't support URL array parameters yet",keyParam);
                }
                [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
                return nil;
            }else if(![serviceComponent isKindOfClass:NSString.class]) {
                if (loggingEnabled) {
                    NSLog(@"[Request Factory] The defined URL param %@ is not a NSString class type: %@",keyParam,serviceComponent);
                }
                [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
                return nil;
            }
        }
        url = [url stringByAppendingURLPathComponent:serviceComponent];
    }
    
    //Set the default headers
    NSMutableDictionary * headers = [[NSMutableDictionary alloc]initWithDictionary:mapHTTP.getHTTPService.getDefaultHeaderParams.dictionary];
    //Set the headers
    [headers addEntriesFromDictionary:mapHTTP.getHeaderParams.dictionary];
    
    //Replace the value vars (${value_var}) using context with header params
    if (mapHTTP.getHTTPService.getContext && headers.count) {
        NSError * error;
        NSDictionary * replacedHeaders = [self replaceContextParamValues:headers usingContext:mapHTTP.getHTTPService.getContext error:&error loggingEnabled:loggingEnabled];
        headers = [[NSMutableDictionary alloc]initWithDictionary:replacedHeaders];
    }
    
    //add header to the request
    for (NSString * key in [headers keyEnumerator]) {
        [urlRequest setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    //Check mandatory header params
    NSDictionary * headerMandatoryParams = mapHTTP.getHTTPService.getMandatoryHeaderParams.dictionary;
    for (NSString * key in [headerMandatoryParams keyEnumerator]) {
        if ([[urlRequest allHTTPHeaderFields]objectForKey:key] == nil) {
            mandatoryFieldsCorrect = NO;
            if (loggingEnabled) {
                NSLog(@"[Request Factory] Mandatory HEADER param: %@ not found",key);
            }
        }
    }
    
    //Set the query params
    if (mapHTTP.getQueryParams.count > 0 || mapHTTP.getHTTPService.getDefaultQueryParams.count > 0) {
        NSError * error;
        NSString * queryString = [self getQueryStringFromMap:mapHTTP error:&error loggingEnabled:loggingEnabled];
        url = [url stringByAppendingURLQuery:queryString];
        if (error) {
            [*errors addObject:error];
            return nil;
        }
    }
    
    //Set body params
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"PATCH"]) {
        if (mapHTTP.getBodyParams) {
            NSString * contentType = [mapHTTP.getHeaderParams objectForKey:@"Content-Type"];
            if (!contentType) {
                contentType = [mapHTTP.getHTTPService.getDefaultHeaderParams objectForKey:@"Content-Type"];
            }
            
            if ([contentType isEqualToString:@"application/json"] || [contentType isEqualToString:@"text/json"]) {
                NSData * params = [mapHTTP.getBodyParams.dictionary valueForKey:kT21APIHTTPMapBodyDataKey];
                if (!params) {
                    // Convert Dictionary to NSData JSON representation
                    NSError * error;
                    NSData * jsonParams = [NSJSONSerialization dataWithJSONObject:mapHTTP.getBodyParams.dictionary options:0 error:&error];
                    NSString * stringJsonParams = [[NSString alloc]initWithData:jsonParams encoding:NSUTF8StringEncoding];
                    //[stringJsonParams URLEncodedString];
                    params = [stringJsonParams dataUsingEncoding:NSUTF8StringEncoding];
                }
                [urlRequest setHTTPBody:params];
            }
            else if ([contentType isEqualToString:@"application/xml"] || [contentType isEqualToString:@"text/xml"]) {
                NSData * params = [mapHTTP.getBodyParams.dictionary valueForKey:kT21APIHTTPMapBodyDataKey];
                if (!params) {
                    if (loggingEnabled) {
                        NSLog(@"[Request Factory] No NSData instance found in bodyParams dictionary with key %@", kT21APIHTTPMapBodyDataKey);
                    }
                }
                [urlRequest setHTTPBody:params];
            }
            else if ([contentType isEqualToString:@"application/x-www-form-urlencoded"]) {
                NSString * queryString = [NSString URLQueryWithParameters:mapHTTP.getBodyParams.dictionary
                                                                  options:URLQueryOptionUseArrays];
                NSData * params = [queryString dataUsingEncoding:NSUTF8StringEncoding];
                [urlRequest setHTTPBody:params];
            }
        } else {
            if (loggingEnabled) {
                NSLog(@"[Request Factory] No body params configured in a http method %@",method);
            }
            /*[*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
             return nil;*/
        }
    }
    
    //Set final url with baseURL + url params + query params
    [urlRequest setURL:[NSURL URLWithString:url]];
    
    //Set cache policy
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    if (!mandatoryFieldsCorrect) {
        [*errors addObject:[NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeIncorrectParameters userInfo:nil]];
        return nil;
    }
    
    if (loggingEnabled) {
        NSLog(@"[Request Factory] Request: [%@] %@\nHeaders:%@", urlRequest.HTTPMethod, urlRequest.URL, urlRequest.allHTTPHeaderFields);
    }
    
    return urlRequest;
}


+(NSString *)getQueryStringFromMap:(T21APIHTTPMap *)mapHTTP error:(NSError**)error loggingEnabled:(BOOL)loggingEnabled
{
    //Add default Query params
    NSMutableDictionary * queryParams = [NSMutableDictionary dictionary];
    if (mapHTTP.getHTTPService.getDefaultUrlParams.dictionary) {
        [queryParams addEntriesFromDictionary:mapHTTP.getHTTPService.getDefaultQueryParams.dictionary];
    }
    
    //Build the URL + url params
    if (mapHTTP.getQueryParams) {
        [queryParams addEntriesFromDictionary:mapHTTP.getQueryParams.dictionary];
    }
    
    //Replace the value vars (${value_var}) using context
    if (mapHTTP.getHTTPService.getContext && queryParams.count) {
        NSDictionary * paramsReplaced = [self replaceContextParamValues:queryParams usingContext:mapHTTP.getHTTPService.getContext error:error loggingEnabled:loggingEnabled];
        [queryParams addEntriesFromDictionary:paramsReplaced];
    }
    
    switch (mapHTTP.getListParameterStrategy) {
        case T21APIRequestParameterListStrategyRepeatParameter:
            return [NSString URLQueryWithParameters:queryParams
                                            options:URLQueryOptionUseArrays];
            break;
        case T21APIRequestParameterListStrategyCommaSeparatedValues:
        case T21APIRequestParameterListStrategyUndefined:
        default:
            return [NSString URLQueryWithParameters:queryParams];
    }
}

+(NSDictionary*)replaceContextParamValues:(NSDictionary*)paramValues usingContext:(T21APIMap*)context error:(NSError**)error loggingEnabled:(BOOL)loggingEnabled
{
    NSMutableDictionary * resultParams = [[NSMutableDictionary alloc] initWithCapacity:paramValues.count];
    [paramValues enumerateKeysAndObjectsUsingBlock:^(NSString * key, id value, BOOL *stop) {
        NSAssert([key isKindOfClass:NSString.class],@"");
        if ([value isKindOfClass:NSString.class]) {
            NSString * paramValue = value;
            if (([paramValue rangeOfString:@"${"].location == 0 || [paramValue rangeOfString:@"{"].location == 0) &&
                paramValue.length > 2 &&
                [paramValue rangeOfString:@"}"].location == paramValue.length - 1) {
                paramValue = [paramValue stringByReplacingOccurrencesOfString:@"${" withString:@""];
                paramValue = [paramValue stringByReplacingOccurrencesOfString:@"{" withString:@""];
                paramValue = [paramValue stringByReplacingOccurrencesOfString:@"}" withString:@""];
                NSString * newValue = [context.dictionary objectForKey:paramValue];
                if (newValue) {
                    paramValue = newValue;
                }else if (error) {
                    if (loggingEnabled) {
                        NSLog(@"[Request Factory] Variable ${%@} not found in context: %@",paramValue,context);
                    }
                    *error = [NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeContextVariableNotFound userInfo:nil];
                }
            }
            [resultParams setObject:paramValue forKey:key];
        }else{
            [resultParams setObject:value forKey:key];
        }
    }];
    return resultParams;
}

@end
