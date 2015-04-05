//
//  Request.h
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

+ (void)getWithPath:(NSString *)path needToken:(BOOL)needToken completionHandler:(id)completionHandler;
+ (void)postWithPath:(NSString *)path param:(NSDictionary *)param needToken:(BOOL)needToken completionHandler:(id)completionHandler;
+ (void)deleteWithPath:(NSString *)path param:(NSDictionary *)param needToekn:(BOOL)needToken comletionHandler:(id)completionHandler;

@end
