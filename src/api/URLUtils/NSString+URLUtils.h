//
//  NSString+URLUtils.h
//  URLUtils
//
//  Version 1.0
//

#import <Foundation/Foundation.h>


typedef enum
{
    URLQueryOptionDefault = 0,
	URLQueryOptionKeepLastValue = 1,
	URLQueryOptionKeepFirstValue = 2,
	URLQueryOptionUseArrays = 3,
	URLQueryOptionAlwaysUseArrays = 4,
	URLQueryOptionUseArraySyntax = 8
}
URLQueryOptions;


@interface NSString (URLUtils)

#pragma mark URLEncoding

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString:(BOOL)decodePlusAsSpace;

#pragma mark URL paths

- (NSString *)stringByAppendingURLPathComponent:(NSString *)str;
- (NSString *)stringByDeletingLastURLPathComponent;
- (NSString *)lastURLPathComponent;

#pragma mark URL query

+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters;
+ (NSString *)URLQueryWithParameters:(NSDictionary *)parameters options:(URLQueryOptions)options;

- (NSString *)URLQuery;
- (NSString *)stringByDeletingURLQuery;
- (NSString *)stringByAppendingURLQuery:(NSString *)query;
- (NSString *)stringByMergingURLQuery:(NSString *)query;
- (NSString *)stringByMergingURLQuery:(NSString *)query options:(URLQueryOptions)options;
- (NSDictionary *)URLQueryParameters;
- (NSDictionary *)URLQueryParametersWithOptions:(URLQueryOptions)options;

#pragma mark URL fragment ID

- (NSString *)URLFragment;
- (NSString *)stringByDeletingURLFragment;
- (NSString *)stringByAppendingURLFragment:(NSString *)fragment;

#pragma mark URL conversion

- (NSURL *)URLValue;
- (NSURL *)URLValueRelativeToURL:(NSURL *)baseURL;

@end
