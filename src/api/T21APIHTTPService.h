//
//  T21APIHTTPService.h
//  T21ContentStore
//
//  Created by Eloi Guzmán on 16/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIMap.h"

typedef enum T21APIHTTPServiceCompareOptions
{
    T21APIHTTPServiceCompareDefault = 3,
    T21APIHTTPServiceComparePath = 1,
    T21APIHTTPServiceCompareMethod = 2,
    T21APIHTTPServiceCompareBaseURL = 4,
    T21APIHTTPServiceCompareName = 8,
    T21APIHTTPServiceCompareParams = 16,
}T21APIHTTPServiceCompareOptions;

@class T21APIHTTPMap;

@interface T21APIHTTPService : T21APIMap

-(id)initWithBaseURL:(NSString*)url path:(NSString*)path httpMethod:(NSString*)m;
-(T21APIHTTPMap*)createHTTPMap;

//Fields
-(void)setPath:(NSString*)value;
-(NSString*)getPath;

-(void)setBaseUrl:(NSString*)value;
-(NSString*)getBaseUrl;

-(void)setHTTPMethod:(NSString*)value;
-(NSString*)getHTTPMethod;

-(void)setName:(NSString*)name;
-(NSString*)getName;

-(void)setParent:(T21APIHTTPService*)parentService;
-(T21APIHTTPService*)getParent;

#pragma mark - Default params
-(void)setDefaultUrlParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultUrlParams;

-(void)setDefaultHeaderParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultHeaderParams;

-(void)setDefaultQueryParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultQueryParams;

#pragma mark - Mandatory params
-(void)setMandatoryUrlParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryUrlParams;

-(void)setMandatoryHeaderParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryHeaderParams;

-(void)setMandatoryQueryParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryQueryParams;

#pragma mark - Context
/**
  A service can be configured using a map context that will replace all the param "values" found in the service definition. It will replace all the expressions surrounded by '${'...'}' or '{'...'}'. Useful to change base params while executing the app. For example change a 'Locale' header param.
 
 @param context map with the keys that will be replaced for each respective value.
 */
-(void)setContext:(T21APIMap*)context;
-(T21APIMap*)getContext;


/**
 Returns the call to -compare with T21APIHTTPServiceCompareDefault option.
 */
- (BOOL)compare:(T21APIHTTPService*)other;

/**
 Returns true if the two services are equal. Use options to specify which fields to compare.
 */
- (BOOL)compare:(T21APIHTTPService*)other options:(T21APIHTTPServiceCompareOptions)options;


//TODO: create an entity HTTPParamsMap with header,query,url,body
/*
 -(void)setDefaultBodyParams:(T21APIMap*)value;
 -(T21APIMap*)getDefaultBodyParams;
 
 */

@end
