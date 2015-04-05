//
//  Travel.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "Travel.h"
#import "Request.h"

NSString *const kTravelPath = @"/travel";

@implementation Travel

- (instancetype)initWithTravelDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.member = dict[@"members"];
        self.places = dict[@"places"];
    }
    return self;
}

/**
 *  参加済みTravel一覧
 */
+ (void)getTravelListWithUserId:(NSString *)userId completionHandler:(void (^)(BOOL, NSArray *, NSError *))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, nil, error);
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"HTTP Error : 404");
            completion(false, nil, error);
            return;
        }
        
        NSMutableArray *travelList = @[].mutableCopy;
        NSDictionary *results = [jsonObj objectForKey:@"result"];
        NSArray *travelArray = [results objectForKey:@"travels"];
        
        for (id travelDictionary in travelArray) {
            Travel *travel = [[Travel alloc] initWithTravelDictionary:travelDictionary];
            [travelList addObject:travel];
        }
        
        completion(true, travelList, nil);
    };
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/joined", kTravelPath, userId];
    [Request getWithPath:path needToken:true completionHandler:completionHandler];
}

/**
 *  Travel詳細
 */
+ (void)getTravelListWithId:(NSString *)travelId completionHandler:(void (^)(BOOL success, Travel *travel, NSError *error))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, nil, error);
            return;
        }
        
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", result);
            completion(false, nil, error);
            return;
        }

        Travel *travel = [[Travel alloc] initWithTravelDictionary:result];
        completion(true, travel, nil);
    };
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kTravelPath, travelId];
    [Request getWithPath:path needToken:false completionHandler:completionHandler];
}

/**
 *  Travel新規作成
 */
+ (void)postTravelWithName:(NSString *)name completionHandler:(void (^)(BOOL success, Travel *travel, NSError *error))completion {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            completion(false, nil, error);
            return;
        }
        
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"%@", result);
            completion(false, nil, error);
            return;
        }

        Travel *travel = [[Travel alloc] initWithTravelDictionary:result];
        completion(true, travel, nil);
    };
    
    NSString *path = kTravelPath;
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:name forKey:@"name"];
    [Request postWithPath:path param:param needToken:true completionHandler:completionHandler];
}


@end
