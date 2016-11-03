//
//  T21APIHTTPService.m
//  T21ContentStore
//
//  Created by Eloi Guzmán on 16/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIHTTPService.h"
#import "T21APIHTTPMap.h"
@implementation T21APIHTTPService

#pragma mark - Inits
-(id)initWithBaseURL:(NSString*)url path:(NSString*)path httpMethod:(NSString*)m
{
    self = [self init];
    if (self) {
        [self setBaseUrl:url];
        [self setPath:path];
        [self setHTTPMethod:m];
    }
    return self;
}

-(T21APIHTTPMap*)createHTTPMap
{
    T21APIHTTPMap * map = [[T21APIHTTPMap alloc]init];
    [map setHTTPService:self];
    return map;
}

#pragma mark - Fields
-(void)setPath:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"path"];
}

-(NSString*)getPath
{
    NSString * v = [self objectForKey:@"path"];
    if (!v) {
        v = [[self getParent] getPath];
    }
    return v;
}

-(void)setBaseUrl:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"baseUrl"];
}

-(NSString*)getBaseUrl
{
    return [self objectForKey:@"baseUrl"];
}

-(void)setHTTPMethod:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"HTTPMethod"];
}

-(NSString*)getHTTPMethod
{
    NSString * v = [self objectForKey:@"HTTPMethod"];
    if (!v) {
        v = [[self getParent] getHTTPMethod];
    }
    return v;
}

-(void)setName:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"name"];
}

-(NSString*)getName
{
    return [self objectForKey:@"name"];
}

-(void)setParent:(T21APIHTTPService*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPService.class],@"Incorrect class type");
    [self setObject:value forKey:@"parent"];
}

-(T21APIHTTPService*)getParent
{
    return [self objectForKey:@"parent"];
}


-(void)setDefaultUrlParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultUrlParams"];
}

-(T21APIMap*)getDefaultUrlParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getDefaultUrlParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"defaultUrlParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setDefaultHeaderParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultHeaderParams"];
}

-(T21APIMap*)getDefaultHeaderParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getDefaultHeaderParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"defaultHeaderParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setDefaultQueryParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultQueryParams"];
}

-(T21APIMap*)getDefaultQueryParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getDefaultQueryParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"defaultQueryParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setMandatoryUrlParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryUrlParams"];
}

-(T21APIMap*)getMandatoryUrlParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getMandatoryUrlParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"MandatoryUrlParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setMandatoryHeaderParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryHeaderParams"];
}

-(T21APIMap*)getMandatoryHeaderParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getMandatoryHeaderParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"MandatoryHeaderParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setMandatoryQueryParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryQueryParams"];
}

-(T21APIMap*)getMandatoryQueryParams
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getMandatoryQueryParams];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"MandatoryQueryParams"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

-(void)setContext:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"Context"];
}

-(T21APIMap*)getContext
{
    T21APIMap * mergedV = [T21APIMap map];
    
    T21APIMap * parentValue = [[self getParent] getContext];
    if (parentValue) {
        [mergedV addMap:parentValue];
    }
    
    T21APIMap * v = [self objectForKey:@"Context"];
    if (v) {
        [mergedV addMap:v];
    }
    return mergedV;
}

- (BOOL)compare:(T21APIHTTPService*)other
{
    return [self compare:other options:T21APIHTTPServiceCompareDefault];
}

- (BOOL)compare:(T21APIHTTPService*)other options:(T21APIHTTPServiceCompareOptions)options
{
    BOOL isEqual = YES;
    if (isEqual && (options & T21APIHTTPServiceCompareBaseURL) && other.getBaseUrl) {
        isEqual = isEqual && [self.getBaseUrl isEqualToString:other.getBaseUrl];
    }
    
    if (isEqual && (options & T21APIHTTPServiceCompareMethod) && other.getHTTPMethod) {
        isEqual = isEqual && [self.getHTTPMethod isEqualToString:other.getHTTPMethod];
    }
    
    if (isEqual && (options & T21APIHTTPServiceComparePath) && other.getPath) {
        isEqual = isEqual && [self.getPath isEqualToString:other.getPath];
    }
    
    if (isEqual && (options & T21APIHTTPServiceCompareName) && other.getName) {
        isEqual = isEqual && [self.getName isEqualToString:other.getName];
    }
    
    if (isEqual && (options & T21APIHTTPServiceCompareParams) && other.getName) {
        isEqual = isEqual && [self isEquivalentMap:[self getDefaultHeaderParams] to:[other getDefaultHeaderParams]];
        isEqual = isEqual && [self isEquivalentMap:[self getMandatoryHeaderParams] to:[other getMandatoryHeaderParams]];
        isEqual = isEqual && [self isEquivalentMap:[self getDefaultUrlParams] to:[other getDefaultUrlParams]];
        isEqual = isEqual && [self isEquivalentMap:[self getMandatoryUrlParams] to:[other getMandatoryUrlParams]];
        isEqual = isEqual && [self isEquivalentMap:[self getDefaultQueryParams] to:[other getDefaultQueryParams]];
        isEqual = isEqual && [self isEquivalentMap:[self getMandatoryQueryParams] to:[other getMandatoryQueryParams]];
    }
    
    return isEqual;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Service: %@ - %@ - %@%@",[self getName],[self getHTTPMethod],[self getBaseUrl],[self getPath]];
}

-(BOOL)isEquivalentMap:(T21APIMap *)map1 to:(T21APIMap *)map2 {
    NSDictionary * dic1 = [map1 dictionary];
    NSDictionary * dic2 = [map2 dictionary];
    if ([dic1 count] == [dic2 count])
    {
        BOOL isEquivalent = YES;
        for (NSString * key in [dic1 keyEnumerator]) {
            NSObject * value1 = [dic1 objectForKey:key];
            NSObject * value2 = [dic2 objectForKey:key];
            isEquivalent = isEquivalent && [value1 isEqual:value2];
        }
        return isEquivalent;
    }
    return NO;
}


@end
