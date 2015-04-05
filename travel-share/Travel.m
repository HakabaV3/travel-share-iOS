//
//  Travel.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "Travel.h"
#import "Request.h"
#import "Notifications.h"

@implementation Travel

- (instancetype)initWithTravelDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.member = dict[@"members"];
        self.places = dict[@"places"];
    }
    return self;
}

+ (void)getTravelList {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            [[NSNotificationCenter defaultCenter] postNotificationName:FailureGetTravelList
                                                                object:self
                                                              userInfo:nil];
            return;
        }
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        
        if ([[jsonObj objectForKey:@"status"] isEqualToString:@"NG"]) {
            NSLog(@"HTTP Error : 404");
            [[NSNotificationCenter defaultCenter] postNotificationName:FailureGetTravelList
                                                                object:self
                                                              userInfo:nil];
            return;
        }
        
        NSMutableArray *travelList = @[].mutableCopy;
        NSDictionary *results = [jsonObj objectForKey:@"result"];
        NSArray *travelArray = [results objectForKey:@"travels"];
        
        for (id travelDictionary in travelArray) {
            Travel *travel = [[Travel alloc] initWithTravelDictionary:travelDictionary];
            [travelList addObject:travel];
        }
        
        NSDictionary *userInfo = @{@"travels" : travelList};
        [[NSNotificationCenter defaultCenter] postNotificationName:SuccessGetTravelList
                                                            object:self
                                                          userInfo:userInfo];
    };
    
    NSString *path = @"/travel";
    [Request getWithPath:path needToken:false completionHandler:completionHandler];
}


+ (void)getTravelListWithId:(NSString *)travelId {
    id completionHandler = ^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        if (jsonData == nil) {
            NSLog(@"JSON Data is nil.");
            [[NSNotificationCenter defaultCenter] postNotificationName:FailureGetTravelObject
                                                                object:self
                                                              userInfo:nil];
            return;
        }
        
        NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
        NSDictionary *results = [jsonObj objectForKey:@"result"];
        
        Travel *travel = [[Travel alloc] initWithTravelDictionary:results];
        
        NSDictionary *userInfo = @{@"travel" : travel};
        [[NSNotificationCenter defaultCenter] postNotificationName:SuccessGetTravelObject
                                                            object:self
                                                          userInfo:userInfo];

    };
    
    NSString *path = [NSString stringWithFormat:@"/travel/%@", travelId];
    [Request getWithPath:path needToken:false completionHandler:completionHandler];
}



@end
