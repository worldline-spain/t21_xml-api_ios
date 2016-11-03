//
//  T21APIHTTPTrait.h
//  T21ContentStore
//
//  Created by Juan Belmonte on 18/07/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import "T21APIMap.h"

@interface T21APIHTTPTrait : T21APIMap

-(void)setName:(NSString*)name;
-(NSString*)getName;

-(void)setDefaultUrlParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultUrlParams;

-(void)setDefaultHeaderParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultHeaderParams;

-(void)setDefaultQueryParams:(T21APIMap*)value;
-(T21APIMap*)getDefaultQueryParams;

-(void)setMandatoryUrlParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryUrlParams;

-(void)setMandatoryHeaderParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryHeaderParams;

-(void)setMandatoryQueryParams:(T21APIMap*)value;
-(T21APIMap*)getMandatoryQueryParams;

@end
