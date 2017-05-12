//
//  T21APIDefinition.h
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIMap.h"
#import "T21APIHTTPService.h"
#import "T21APIHTTPTrait.h"

@interface T21APIDefinition : T21APIMap
{
    NSMutableDictionary * _serviceNames;
    NSMutableDictionary * _traitNames;
}


-(void)setBaseUrl:(NSString*)baseUrl;
-(NSString*)getBaseUrl;

-(void)addService:(T21APIHTTPService*)service;
-(void)removeService:(T21APIHTTPService*)service;

-(T21APIHTTPService*)getService:(NSString*)serviceIdentifier;
-(T21APIHTTPService*)getService:(NSString*)serviceIdentifier usingContext:(T21APIMap*)context;

-(T21APIHTTPMap*)getServiceMap:(NSString*)serviceIdentifier;
-(T21APIHTTPMap*)getServiceMap:(NSString*)serviceIdentifier usingContext:(T21APIMap*)context;

-(void)addTrait:(T21APIHTTPTrait*)trait;
-(void)removeTrait:(T21APIHTTPTrait*)trait;
-(T21APIHTTPTrait*)getTrait:(NSString*)traitIdentifier;

-(NSArray*)getServiceArray;

-(BOOL)validateApi:(NSError**)error;

@end
