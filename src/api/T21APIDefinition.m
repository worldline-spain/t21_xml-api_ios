//
//  T21APIDefinition.m
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIDefinition.h"
#import "T21APIErrors.h"

@implementation T21APIDefinition

-(void)setBaseUrl:(NSString*)value
{
    NSAssert([value isKindOfClass:NSString.class],@"Incorrect class type");
    [self setObject:value forKey:@"baseUrl"];
    
    // Redefine services' base URL
    T21APIMap * servicesCollection = [self getServices];
    for (T21APIHTTPService * service in [servicesCollection allObjects]) {
        [service setBaseUrl:value];
    }
}

-(NSString*)getBaseUrl
{
    return [self objectForKey:@"baseUrl"];
}


-(void)addService:(T21APIHTTPService*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPService.class],@"Incorrect class type");
    
    T21APIMap * servicesCollection = [self getServices];
    if (!servicesCollection) {
        servicesCollection = [[T21APIMap alloc]init];
        [self setObject:servicesCollection forKey:@"services"];
    }
    [servicesCollection setObject:value forKey:[value getName]];
}

-(void)removeService:(T21APIHTTPService*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPService.class],@"Incorrect class type");
    
    T21APIMap * servicesCollection = [self getServices];
    [servicesCollection takeObjectForKey:[value getName]];
}


-(T21APIHTTPService*)getService:(NSString*)serviceIdentifier usingContext:(T21APIMap*)context
{
    NSAssert(serviceIdentifier,@"serviceIdentifier cannot be nil");
    
    T21APIMap * servicesCollection = [self getServices];
    T21APIHTTPService * service = [servicesCollection objectForKey:serviceIdentifier];
    service = [service copy];
    if (context.count > 0) {
        [service setContext:context];
    }
    return service;
}

-(T21APIHTTPService*)getService:(NSString*)serviceIdentifier
{
    return [self getService:serviceIdentifier usingContext:nil];
}


-(T21APIHTTPMap*)getServiceMap:(NSString*)serviceIdentifier usingContext:(T21APIMap*)context
{
    T21APIHTTPService * srv = [self getService:serviceIdentifier usingContext:context];
    return [srv createHTTPMap];
}

-(T21APIHTTPMap*)getServiceMap:(NSString*)serviceIdentifier
{
    return [self getServiceMap:serviceIdentifier usingContext:nil];
}

-(T21APIMap *)getServices
{
    return [self objectForKey:@"services"];
}


-(void)addTrait:(T21APIHTTPTrait*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPTrait.class],@"Incorrect class type");
    
    T21APIMap * traitsCollection = [self objectForKey:@"traits"];
    if (!traitsCollection) {
        traitsCollection = [[T21APIMap alloc]init];
        [self setObject:traitsCollection forKey:@"traits"];
    }
    [traitsCollection setObject:value forKey:[value getName]];
}

-(void)removeTrait:(T21APIHTTPTrait*)value
{
    NSAssert([value isKindOfClass:T21APIHTTPService.class],@"Incorrect class type");
    
    T21APIMap * traitsCollection = [self objectForKey:@"traits"];
    [traitsCollection takeObjectForKey:[value getName]];
}

-(T21APIHTTPTrait*)getTrait:(NSString*)traitIdentifier
{
    NSAssert(traitIdentifier,@"serviceIdentifier cannot be nil");
    
    T21APIMap * traitsCollection = [self objectForKey:@"traits"];
    return [traitsCollection objectForKey:traitIdentifier];
}

-(BOOL)validateApi:(NSError**)error
{
    //Validate base url
    if(![self getBaseUrl])
    {
        if (error) {
            *error = [NSError errorWithDomain:T21APIErrorDomain code:T21APIErrorCodeBaseURLNotFound userInfo:nil];
        }
        return NO;
    }
    
    //Validate services
    //TODO:
    
    return YES;
}

-(NSString *)description
{
    NSMutableString * desc = [[NSMutableString alloc]init];
    [desc appendFormat:@"API - BaseURL: %@ \n",[self getBaseUrl]];

    [desc appendFormat:@"Properties: \n"];
//    T21APIMap * traitsCollection = [self objectForKey:@"traits"];
//    if (traitsCollection) {
//        for (T21APIHTTPTrait * trait in [traitsCollection allSenders]) {
//            NSAssert([trait isKindOfClass:[T21APIHTTPTrait class]],@"No T21APIHTTPTrait class type.");
//            [desc appendFormat:@"-> %@ \n",[trait description]];
//        }
//    }
    
    [desc appendFormat:@"Traits: \n"];
    T21APIMap * traitsCollection = [self objectForKey:@"traits"];
    if (traitsCollection) {
        for (T21APIHTTPTrait * trait in [traitsCollection allObjects]) {
            NSAssert([trait isKindOfClass:[T21APIHTTPTrait class]],@"No T21APIHTTPTrait class type.");
            [desc appendFormat:@"-> %@ \n",[trait description]];
        }
    }

    [desc appendFormat:@"Services: \n"];
    T21APIMap * servicesCollection = [self objectForKey:@"services"];
    if (servicesCollection) {
        for (T21APIHTTPService * srv in [servicesCollection allObjects]) {
            NSAssert([srv isKindOfClass:[T21APIHTTPService class]],@"No T21APIHTTPService class type.");
            [desc appendFormat:@"-> %@ \n",[srv description]];
        }
    }
    return desc;
}



@end
