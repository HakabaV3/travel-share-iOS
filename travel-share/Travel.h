//
//  Travel.h
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Travel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *member;
@property (nonatomic, strong) NSArray *places;

+ (void)getTravelListWithUserId:(NSString *)userId completionHandler:(void (^)(BOOL success, NSArray *travels, NSError *error))completion;
+ (void)getTravelListWithId:(NSString *)travelId completionHandler:(void (^)(BOOL success, Travel *travel, NSError *error))completion;
+ (void)postTravelWithName:(NSString *)name completionHandler:(void (^)(BOOL success, Travel *travel, NSError *error))completion;

@end

