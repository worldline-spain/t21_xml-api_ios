//
//  T21APIMap.h
//  MyPod
//
//  Created by Eloi Guzmán Cerón on 02/11/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T21APIMap : NSObject <NSCopying>
{
    NSMapTable * _proxy;
}

#pragma mark - Public

+(instancetype)map;
+(instancetype)mapWithDict:(NSDictionary*)dict;

-(void)addMap:(T21APIMap*)map;
-(void)addDictionary:(NSDictionary*)dict;

-(void)setObject:(NSObject*)object forKey:(NSObject*)keyObject;
-(id)takeObjectForKey:(NSObject*)keyObject;
-(id)objectForKey:(NSObject*)keyObject;

-(NSArray *)allObjects;
-(NSArray *)allKeyObjects;
-(NSEnumerator*)keysEnumerator;
-(NSEnumerator*)objectsEnumerator;
-(NSUInteger)count;
-(void)deleteAll;
-(NSDictionary*)dictionary;

#pragma mark - Protected
-(void)privateInitMapTable;

@end
