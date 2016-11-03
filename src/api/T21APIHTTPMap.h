//
//  T21APIHTTPMap.h
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/12/13.
//  Copyright (c) 2013 Eloi Guzmán. All rights reserved.
//

#import "T21APIMap.h"
#import "T21APIHTTPService.h"

/*!
 @enum
 
 This enumeration defines different strategies to handle request parameters
 defined as a NSArray.
 
 @constant T21CSRequestParameterListStrategyRepeatParameter Repeat the parameter name for each value in the list
 @constant T21CSRequestParameterListStrategyCommaSeparatedValues Join all values into a comma-separated string and send them as a single request parameter
 @constant T21CSRequestParameterListStrategyUndefined Undefined strategy
 */
typedef enum T21APIRequestParameterListStrategy
{
    T21APIRequestParameterListStrategyRepeatParameter = 0, // Repeat the parameter name for each value in the list
    T21APIRequestParameterListStrategyCommaSeparatedValues, // Join all values into a comma-separated string and send them as a single request parameter
    
    T21APIRequestParameterListStrategyUndefined = 500 // Undefined value
} T21APIRequestParameterListStrategy;


/*!
 @constant
 
 Set this constant in the T21APIMap to add an instance of NSData as full body content.
 
 @see setBodyParams
 */
extern NSString * const kT21APIHTTPMapBodyDataKey;



@interface T21APIHTTPMap : T21APIMap

-(void)setHTTPService:(T21APIHTTPService*)value;
-(T21APIHTTPService*)getHTTPService;

-(void)setUrlParams:(T21APIMap*)value;
-(T21APIMap*)getUrlParams;

-(void)setQueryParams:(T21APIMap*)value;
-(T21APIMap*)getQueryParams;

/*!
 @method
 
 This methods configures all body parameters specified in the input T21APIMap instance.
 
 The dictionary will be serialized according to 'Content-Type' header.

 It's possible to set a single key kT21APIHTTPMapBodyDataKey associated to a NSData instance.
 If the kT21APIHTTPMapBodyDataKey is found, the associated value must be an instance of NSData and no other key can be defined.
 
 @see kT21APIHTTPMapBodyDataKey
 
 @param value T21APIMap instance
 */
-(void)setBodyParams:(T21APIMap*)value;

/*!
 @method
 
 This method returns all configured body parameters, if any.
 Changes applied to the returned instance will not affect the actual body parameters to ensure integrity. Use `setBodyParams` again instead.
 
 @return Disconnected T21APIMap instance
 */
-(T21APIMap*)getBodyParams;

-(void)setHeaderParams:(T21APIMap*)value;
-(T21APIMap*)getHeaderParams;

-(void)setListParameterStrategy:(T21APIRequestParameterListStrategy)value;
-(T21APIRequestParameterListStrategy)getListParameterStrategy;

/**
 This method returns an NSMutableURLRequest initialized with the properties inside the receiver.
 
 @param errors Return value that contains the possible errors found.
 
 @return the resulting NSMutableURLRequest.
 */
-(NSMutableURLRequest*)createURLRequest:(NSMutableArray**)errors;

@end
