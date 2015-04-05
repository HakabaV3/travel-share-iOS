//
//  LoginManager.h
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

@property BOOL isLogin;

+ (LoginManager *)sharedManager;

- (void)me:(void (^)(BOOL success, NSError *error))completion;
- (void)loginWithId:(NSString *)userId password:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completion;
- (void)signupWithId:(NSString *)userId userName:(NSString *)name password:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completion;
- (void)logout;
- (void)resign:(void (^)(BOOL success, NSError *error))completion;

- (NSString *)accessToken;
- (NSString *)userId;
- (NSString *)userName;
- (NSString *)password;

@end
