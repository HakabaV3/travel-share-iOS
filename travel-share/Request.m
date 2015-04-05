//
//  Request.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "Request.h"
#import "LoginManager.h"

@implementation Request

NSString *const kServerDomain = @"http://localhost:3000/api/v1";

+ (NSMutableURLRequest *)urlRequestWithPath:(NSString *)path param:(NSDictionary *)param needToken:(BOOL)needToken {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerDomain, path];
    NSURL *url = [NSURL URLWithString:urlStr];

    NSLog(@"\nURL: %@", urlStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (param) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:2 error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSLog(@"\nHTTPBody: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    if (needToken) {
        [request setValue:[[LoginManager sharedInstance] accessToken] forHTTPHeaderField:@"X-Token"];
    }
    return request;
}

+ (void)getWithPath:(NSString *)path needToken:(BOOL)needToken completionHandler:(id)completionHandler {
    LOG_METHOD;
    NSMutableURLRequest *request = [Request urlRequestWithPath:path param:nil needToken:needToken];
    request.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: completionHandler];
}

+ (void)postWithPath:(NSString *)path param:(NSDictionary *)param needToken:(BOOL)needToken completionHandler:(id)completionHandler {
    LOG_METHOD;
    NSMutableURLRequest *request = [Request urlRequestWithPath:path param:param needToken:needToken];
    request.HTTPMethod = @"POST";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:completionHandler];
}

+ (void)deleteWithPath:(NSString *)path param:(NSDictionary *)param needToekn:(BOOL)needToken comletionHandler:(id)completionHandler {
    LOG_METHOD;
    NSMutableURLRequest *request = [Request urlRequestWithPath:path param:param needToken:needToken];
    request.HTTPMethod = @"DELETE";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:completionHandler];
}

@end
