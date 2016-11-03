//
//  T21APIErrors.h
//  MyPod
//
//  Created by Eloi Guzmán Cerón on 02/11/16.
//  Copyright © 2016 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const T21APIErrorDomain;

typedef NS_ENUM(NSInteger,T21APIErrorCode) {
    T21APIErrorCodeUnknown = 0,
    T21APIErrorCodeBaseURLNotFound = 1,
    T21APIErrorCodeIncorrectXML = 2,
    T21APIErrorCodeIncorrectParameters = 3,
    T21APIErrorCodeContextVariableNotFound = 4,
};
