//
//  T21APIHTTPTrait.m
//  T21ContentStore
//
//  Created by Juan Belmonte on 18/07/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIHTTPTrait.h"


@implementation T21APIHTTPTrait

#pragma mark - Fields

-(void)setName:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"name"];
}

-(NSString*)getName
{
    return [self objectForKey:@"name"];
}

-(void)setDefaultUrlParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultUrlParams"];
}

-(T21APIMap*)getDefaultUrlParams
{
    return [self objectForKey:@"defaultUrlParams"];
}

-(void)setDefaultHeaderParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultHeaderParams"];
}

-(T21APIMap*)getDefaultHeaderParams
{
    return [self objectForKey:@"defaultHeaderParams"];
}

-(void)setDefaultQueryParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"defaultQueryParams"];
}

-(T21APIMap*)getDefaultQueryParams
{
    return [self objectForKey:@"defaultQueryParams"];
}

-(void)setMandatoryUrlParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryUrlParams"];
}

-(T21APIMap*)getMandatoryUrlParams
{
    return [self objectForKey:@"MandatoryUrlParams"];
}

-(void)setMandatoryHeaderParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryHeaderParams"];
}

-(T21APIMap*)getMandatoryHeaderParams
{
    return [self objectForKey:@"MandatoryHeaderParams"];
}

-(void)setMandatoryQueryParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"MandatoryQueryParams"];
}

-(T21APIMap*)getMandatoryQueryParams
{
    return [self objectForKey:@"MandatoryQueryParams"];
}

@end
