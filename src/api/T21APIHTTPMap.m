//
//  T21APIHTTPMap.m
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/12/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "T21APIHTTPMap.h"
//#import "T21CSNetworkConfigurationJob.h"

NSString * const kT21APIHTTPMapBodyDataKey = @"k_kT21APIHTTPMapBodyDataKey";

@implementation T21APIHTTPMap

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUrlParams:[[T21APIMap alloc]init]];
        [self setQueryParams:[[T21APIMap alloc]init]];
        [self setBodyParams:[[T21APIMap alloc]init]];
        [self setHeaderParams:[[T21APIMap alloc]init]];
    }
    return self;
}

-(void)setHTTPService:(T21APIHTTPService*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPService.class],@"Incorrect class type");
    [self setObject:value forKey:@"httpService"];
}

-(T21APIHTTPService*)getHTTPService
{
    return (T21APIHTTPService*)[self objectForKey:@"httpService"];
}

-(void)setUrlParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"urlParams"];
}

-(T21APIMap*)getUrlParams
{
    return [self objectForKey:@"urlParams"];
}

-(void)setQueryParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"queryParams"];
}

-(T21APIMap*)getQueryParams
{
    return (T21APIMap*)[self objectForKey:@"queryParams"];
}

-(void)setBodyParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    
    // Full body as NSData object
    NSData * dataObj = [value.dictionary objectForKey:kT21APIHTTPMapBodyDataKey];
    if (dataObj) {
        NSAssert([dataObj isKindOfClass:[NSData class]], @"%@ entry must be of type NSData", kT21APIHTTPMapBodyDataKey);
        NSAssert(value.count == 1, @"When %@ key is setted, it must be the only setted property", kT21APIHTTPMapBodyDataKey);
    }
    
    [self setObject:value forKey:@"bodyParams"];
}

-(T21APIMap*)getBodyParams
{
    // Return a copy to avoid updating illegally the T21APIMap instance
    T21APIMap * bodyParams = (T21APIMap*)[self objectForKey:@"bodyParams"];
    return [T21APIMap mapWithDict:bodyParams.dictionary];
}

-(void)setHeaderParams:(T21APIMap*)value
{
    NSAssert([value isKindOfClass:T21APIMap.class],@"Incorrect class type");
    [self setObject:value forKey:@"headerParams"];
}

-(T21APIMap*)getHeaderParams
{
    return (T21APIMap*)[self objectForKey:@"headerParams"];
}

-(void)setListParameterStrategy:(T21APIRequestParameterListStrategy)value
{
    [self setObject:[NSNumber numberWithUnsignedInt:value] forKey:@"listParamStrategy"];
}

-(T21APIRequestParameterListStrategy)getListParameterStrategy
{
    NSNumber * value = [self objectForKey:@"listParamStrategy"];
    return value? (T21APIRequestParameterListStrategy)[value unsignedIntValue] : T21APIRequestParameterListStrategyUndefined;
}

-(NSMutableURLRequest*)createURLRequest:(NSMutableArray**)errors
{
//    return [T21CSNetworkConfigurationJob configureURLRequest:nil withMap:self errors:errors];
    return nil;
}


@end
