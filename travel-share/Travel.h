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

+ (void)getTravelList;
+ (void)getTravelListWithId:(NSString *)travelId;

@end

