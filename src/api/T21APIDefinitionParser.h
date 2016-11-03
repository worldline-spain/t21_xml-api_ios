//
//  T21APIDefinitionParser.h
//  T21ContentStore
//
//  Created by Eloi Guzmán on 17/01/14.
//  Copyright (c) 2014 Eloi Guzmán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T21APIDefinition.h"

@class DDXMLDocument;

@interface T21APIDefinitionParser : NSObject<NSXMLParserDelegate>
{
    DDXMLDocument * _document;
    T21APIDefinition * _definition;
    T21APIHTTPService * _service;
}

@property (nonatomic,strong) NSMutableArray *apiDefinitionItems;
@property (nonatomic) BOOL loggingEnabled;

-(T21APIDefinition*)getApiDefinitionForData:(NSData*)data;
-(T21APIDefinition*)getApiDefinitionForFile:(NSString*)file;
-(T21APIDefinition*)getApiDefinitionForFile:(NSString*)file bundle:(NSBundle*)bundle;

@end
