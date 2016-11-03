//
//  T21APIMap.m
//  MyPod
//
//  Created by Eloi Guzmán Cerón on 02/11/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import "T21APIMap.h"

@implementation T21APIMap

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self privateInitMapTable];
    }
    return self;
}

+(instancetype)map {
    return [[T21APIMap alloc]init];
}

+(instancetype)mapWithDict:(NSDictionary*)dict {
    T21APIMap * map = [[T21APIMap alloc]init];
    [map addDictionary:dict];
    return map;
}

-(void)addMap:(T21APIMap*)map {
    for (NSString * key in map.allKeyObjects) {
        [self setObject:[map objectForKey:key] forKey:key];
    }
}

-(void)addDictionary:(NSDictionary*)dict {
    for (NSString * key in dict.allKeys) {
        [self setObject:[dict objectForKey:key] forKey:key];
    }
}

-(void)privateInitMapTable {
    _proxy = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                       valueOptions:NSPointerFunctionsStrongMemory
                                           capacity:5];
}

-(void)setObject:(NSObject*)object forKey:(NSObject*)keyObject {
    
    NSString * key = (NSString*)keyObject;
    if (![keyObject isKindOfClass:NSString.class]) {
        key = [NSString stringWithFormat:@"%lu",(unsigned long)[keyObject hash]];
    }
    
    if (object) {
        [_proxy setObject:object forKey:key];
    } else {
        [_proxy removeObjectForKey:key];
    }
}

-(id)takeObjectForKey:(NSObject*)keyObject {
    
    NSString * key = (NSString*)keyObject;
    if (![keyObject isKindOfClass:NSString.class]) {
        key = [NSString stringWithFormat:@"%lu",(unsigned long)[keyObject hash]];
    }
    
    id obj = [_proxy objectForKey:key];
    if (obj) {
        [_proxy removeObjectForKey:key];
    }
    return obj;
}

-(id)objectForKey:(NSObject*)keyObject {
    
    NSString * key = (NSString*)keyObject;
    if (![keyObject isKindOfClass:NSString.class]) {
        key = [NSString stringWithFormat:@"%lu",(unsigned long)[keyObject hash]];
    }
    
    return [_proxy objectForKey:key];
}


-(NSArray *)allKeyObjects
{
    NSArray * res = self.keysEnumerator.allObjects;
    return res;
}

-(NSArray *)allObjects
{
    NSArray * res = self.objectsEnumerator.allObjects;
    return res;
}

-(NSEnumerator *)keysEnumerator
{
    NSEnumerator * e = _proxy.keyEnumerator;
    return e;
}

-(NSEnumerator *)objectsEnumerator
{
    NSEnumerator * e = _proxy.objectEnumerator;
    return e;
}

-(NSUInteger)count
{
    NSUInteger count = _proxy.count;
    return count;
}

-(NSDictionary*)dictionary
{
    NSDictionary * r = [_proxy dictionaryRepresentation];
    return r;
}

-(void)deleteAll
{
    [_proxy removeAllObjects];
}

-(void)dealloc
{
    [_proxy removeAllObjects];
    _proxy = nil;
}

-(NSString *)description
{
    return [_proxy description];
}

-(id)copyWithZone:(NSZone *)zone
{
    T21APIMap * copy = [[self.class alloc] init];
    [copy addDictionary:self.dictionary];
    return copy;
}

@end
