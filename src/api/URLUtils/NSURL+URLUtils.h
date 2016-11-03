//
//  NSURL+URLUtils.h
//  URLUtils
//
//  Version 1.0
//

#import <Foundation/Foundation.h>


extern NSString *const URLSchemeComponent;
extern NSString *const URLHostComponent;
extern NSString *const URLPortComponent;
extern NSString *const URLUserComponent;
extern NSString *const URLPasswordComponent;
extern NSString *const URLPathComponent;
extern NSString *const URLParameterStringComponent;
extern NSString *const URLQueryComponent;
extern NSString *const URLFragmentComponent;


@interface NSURL (URLUtils)

+ (NSURL *)URLWithComponents:(NSDictionary *)components;
- (NSDictionary *)components;

- (NSURL *)URLWithScheme:(NSString *)scheme;
- (NSURL *)URLWithHost:(NSString *)host;
- (NSURL *)URLWithPort:(NSString *)port;
- (NSURL *)URLWithUser:(NSString *)user;
- (NSURL *)URLWithPassword:(NSString *)password;
- (NSURL *)URLWithPath:(NSString *)path;
- (NSURL *)URLWithParameterString:(NSString *)parameterString;
- (NSURL *)URLWithQuery:(NSString *)query;
- (NSURL *)URLWithFragment:(NSString *)fragment;

@end
