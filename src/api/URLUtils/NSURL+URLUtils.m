//
//  NSURL+URLUtils.m
//  URLUtils
//
//  Version 1.0
//

#import "NSURL+URLUtils.h"


NSString *const URLSchemeComponent = @"scheme";
NSString *const URLHostComponent = @"host";
NSString *const URLPortComponent = @"port";
NSString *const URLUserComponent = @"user";
NSString *const URLPasswordComponent = @"password";
NSString *const URLPathComponent = @"path";
NSString *const URLParameterStringComponent = @"parameterString";
NSString *const URLQueryComponent = @"query";
NSString *const URLFragmentComponent = @"fragment";


@implementation NSURL (URLUtils)

+ (NSURL *)URLWithComponents:(NSDictionary *)components
{
    NSString *URL = @"";
    NSString *fragment = [components objectForKey:URLFragmentComponent];
    if (fragment)
    {
        URL = [NSString stringWithFormat:@"#%@", fragment];
    }
    NSString *query = [components objectForKey:URLQueryComponent];
    if (query)
    {
        URL = [NSString stringWithFormat:@"?%@%@", query, URL];
    }
    NSString *parameterString = [components objectForKey:URLParameterStringComponent];
    if (parameterString)
    {
        URL = [NSString stringWithFormat:@";%@%@", parameterString, URL];
    }
    NSString *path = [components objectForKey:URLPathComponent];
    if (path)
    {
        URL = [path stringByAppendingString:URL];
    }
    NSString *port = [components objectForKey:URLPortComponent];
    if (port)
    {
        URL = [NSString stringWithFormat:@":%@%@", port, URL];
    }
    NSString *host = [components objectForKey:URLHostComponent];
    if (host)
    {
        URL = [host stringByAppendingString:URL];
    }
    NSString *user = [components objectForKey:URLUserComponent];
    if (user)
    {
        NSString *password = [components objectForKey:URLPasswordComponent];
        if (password)
        {
            user = [user stringByAppendingFormat:@":%@", password];
        }
        URL = [user stringByAppendingFormat:@"@%@", URL];
    }
    NSString *scheme = [components objectForKey:URLSchemeComponent];
    if (scheme)
    {
        URL = [scheme stringByAppendingFormat:@"://%@", URL];
    }
    return [NSURL URLWithString:URL];
}

- (NSDictionary *)components
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *key in [NSArray arrayWithObjects:
                           URLSchemeComponent, URLHostComponent,
                           URLPortComponent, URLUserComponent,
                           URLPasswordComponent, URLPortComponent,
                           URLParameterStringComponent, URLQueryComponent,
                           URLFragmentComponent,
                           nil])
    {
        id value = [self valueForKey:key];
        if (value)
        {
            [result setObject:value forKey:key];
        }
    }
    return result;
}

- (NSURL *)URLWithValue:(NSString *)value forComponent:(NSString *)component
{
    NSMutableDictionary *components = [[self components] mutableCopy];
    
#if !__has_feature(objc_arc)
    [components autorelease];
#endif
    
    if (value)
    {
        [components setObject:value  forKey:component];
    }
    else
    {
        [components removeObjectForKey:component];
    }
    return [NSURL URLWithComponents:components];
}

- (NSURL *)URLWithScheme:(NSString *)scheme
{
    NSString *URL = [self absoluteString];
    URL = [URL substringFromIndex:[[self scheme] length]];
    return [NSURL URLWithString:[scheme stringByAppendingString:URL]];
}

- (NSURL *)URLWithHost:(NSString *)host
{
    return [self URLWithValue:host forComponent:URLHostComponent];
}

- (NSURL *)URLWithPort:(NSString *)port
{
    return [self URLWithValue:port forComponent:URLPortComponent];
}

- (NSURL *)URLWithUser:(NSString *)user
{
    return [self URLWithValue:user forComponent:URLUserComponent];
}

- (NSURL *)URLWithPassword:(NSString *)password
{
    return [self URLWithValue:password forComponent:URLPasswordComponent];
}

- (NSURL *)URLWithPath:(NSString *)path
{
    return [self URLWithValue:path forComponent:URLPasswordComponent];
}

- (NSURL *)URLWithParameterString:(NSString *)parameterString
{
    return [self URLWithValue:parameterString forComponent:URLParameterStringComponent];
}

- (NSURL *)URLWithQuery:(NSString *)query
{
    return [self URLWithValue:query forComponent:URLQueryComponent];
}

- (NSURL *)URLWithFragment:(NSString *)fragment
{
    return [self URLWithValue:fragment forComponent:URLFragmentComponent];
}

@end
