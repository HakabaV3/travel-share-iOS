//
//  Alert.h
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert : NSObject

@property (nonatomic, weak) id parentViewController;

- (instancetype)initWithParentViewController:(id)parentViewController;
- (void)showWithErrorMessage:(NSString *)message;
- (void)showWithLogoutMessage;
- (void)showWithResignMessage;

@end
