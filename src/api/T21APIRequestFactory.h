//
//  T21APIRequestFactory.h
//  MyPod
//
//  Created by Eloi Guzmán Cerón on 02/11/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T21APIHTTPMap.h"

@interface T21APIRequestFactory : NSObject

+(NSMutableURLRequest*)configureURLRequest:(NSMutableURLRequest*)urlRequest withMap:(T21APIHTTPMap*)mapHTTP errors:(NSMutableArray**)errors;
+(NSMutableURLRequest*)configureURLRequest:(NSMutableURLRequest*)urlRequest withMap:(T21APIHTTPMap*)mapHTTP errors:(NSMutableArray**)errors loggingEnabled:(BOOL)loggingEnabled;

@end
