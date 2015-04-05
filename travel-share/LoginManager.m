//
//  LoginManager.m
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "LoginManager.h"
#import "Request.h"

#import <UICKeyChainStore/UICKeyChainStore.h>

NSString *const kAccessTokenKey = @"kAccessTokenKey";
NSString *const kUserIdKey = @"kUserIdKey";
NSString *const kUserNameKey = @"kUserNameKey";
NSString *const kUserPasswordKey = @"kUserPasswordKey";

@interface LoginManager ()

@end

@implementation LoginManager

static LoginManager *s_self = nil;

+ (LoginManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_self = [[LoginManager alloc] init];
        [s_self initManager];
    });
    return s_self;
}

- (void)initManager {
    LOG_METHOD;
    self.isLogin = false;
}

/**
 *  認証済みユーザーの確認
 */
- (void)me:(void (^)(BOOL success, NSError *error))completion {
    id completionHandelr = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            completion(false, error);
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", [jsonObj objectForKey:@"result"]);
            completion(false, error);
            return;
        }
        
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        NSDictionary *userInfo = result[@"user"];
        self.isLogin = true;
        [self setAccessToken:result[@"token"]];
        [self setUserId:userInfo[@"userId"]];
        [self setUserName:userInfo[@"name"]];

        completion(true, nil);
    };
    
    NSString *path = @"/auth";
    [Request getWithPath:path needToken:true completionHandler:completionHandelr];
}

/**
 *  IDとPasswordでログイン
 */
- (void)loginWithId:(NSString *)userId password:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, error);
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", [jsonObj objectForKey:@"result"]);
            completion(false, error);
            return;
        }
        
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        NSDictionary *userInfo = result[@"user"];
        self.isLogin = true;
        [self setAccessToken:result[@"token"]];
        [self setUserId:userInfo[@"userId"]];
        [self setUserName:userInfo[@"name"]];
        [self setPassword:password];
        
        completion(true, nil);
    };
    
    NSString *path = [NSString stringWithFormat:@"/auth/%@", userId];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:password forKey:@"password"];
    [Request postWithPath:path param:param needToken:false completionHandler:completionHandler];
}

/**
 *  ユーザー登録
 */
- (void)signupWithId:(NSString *)userId userName:(NSString *)name password:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, error);
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", [jsonObj objectForKey:@"result"]);
            completion(false, error);
            return;
        }
        
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        [self setUserId:result[@"userId"]];
        [self setUserName:result[@"name"]];
        [self setPassword:password];
        
        completion(true, nil);
    };
    
    NSString *path = [NSString stringWithFormat:@"/user/%@", userId];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:password forKey:@"password"];
    [param setValue:name forKey:@"name"];
    [Request postWithPath:path param:param needToken:false completionHandler:completionHandler];
}

/**
 *  ログアウト
 */
- (void)logout {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", jsonObj);
            return;
        }
        
        [self resetStatus];
        
    };
    
    NSString *path = [NSString stringWithFormat:@"/auth/%@", [self userId]];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:[self password] forKey:@"password"];
    [Request deleteWithPath:path param:param needToekn:true comletionHandler:completionHandler];
}

/**
 *  退会処理
 */
- (void)resign:(void (^)(BOOL success, NSError *error))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, error);
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", [jsonObj objectForKey:@"result"]);
            completion(false, error);
            return;
        }
        
        [self resetStatus];
        
        completion(true, nil);
    };
    
    NSString *path = [NSString stringWithFormat:@"/user/%@", [self userId]];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:[self password] forKey:@"password"];
    [Request deleteWithPath:path param:param needToekn:true comletionHandler:completionHandler];
}

#pragma mark - UICKeyChainStore

- (void)resetStatus {
    self.isLogin = false;
    [UICKeyChainStore removeItemForKey:kAccessTokenKey];
    [UICKeyChainStore removeItemForKey:kUserIdKey];
    [UICKeyChainStore removeItemForKey:kUserPasswordKey];
}

- (void)setAccessToken:(NSString *)token {
    [UICKeyChainStore setString:token forKey:kAccessTokenKey];
}

- (void)setUserId:(NSString *)userId {
    [UICKeyChainStore setString:userId forKey:kUserIdKey];
}

- (void)setUserName:(NSString *)userName {
    [UICKeyChainStore setString:userName forKey:kUserNameKey];
}

- (void)setPassword:(NSString *)password {
    [UICKeyChainStore setString:password forKey:kUserPasswordKey];
}

- (NSString *)accessToken {
    return [UICKeyChainStore stringForKey:kAccessTokenKey];
}

- (NSString *)userId {
    return [UICKeyChainStore stringForKey:kUserIdKey];
}

- (NSString *)userName {
    return [UICKeyChainStore stringForKey:kUserNameKey];
}

- (NSString *)password {
    return [UICKeyChainStore stringForKey:kUserPasswordKey];
}


@end
