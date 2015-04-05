//
//  Alert.m
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "Alert.h"
#import "LoginManager.h"

@interface Alert ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation Alert

- (instancetype)initWithParentViewController:(id)parentViewController {
    if (self == [super init]) {
        self.parentViewController = parentViewController;
    }
    return self;
}

- (void)showWithErrorMessage:(NSString *)message {
    self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alertController addAction:[self cancelActionWithTitle:@"OK"]];
    
    [self.parentViewController presentViewController:self.alertController animated:YES completion:nil];
}

- (void)showWithLogoutMessage {
    self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                               message:@"ログアウトしますか？"
                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alertController addAction:[self cancelActionWithTitle:@"NO"]];
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[LoginManager sharedManager] logout];
        [self.alertController dismissViewControllerAnimated:true completion:nil];
        [self.parentViewController dismissViewControllerAnimated:true completion:nil];
    }]];
    
    [self.parentViewController presentViewController:self.alertController animated:YES completion:nil];
}

- (void)showWithResignMessage {
    self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                               message:@"退会しますか？"
                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alertController addAction:[self cancelActionWithTitle:@"NO"]];
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[LoginManager sharedManager] resign:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"失敗");
            }
            [self.alertController dismissViewControllerAnimated:true completion:nil];
            [self.parentViewController dismissViewControllerAnimated:true completion:nil];
        }];
    }]];
    
    [self.parentViewController presentViewController:self.alertController animated:YES completion:nil];
}

- (UIAlertAction *)cancelActionWithTitle:(NSString *)title {
    return [UIAlertAction actionWithTitle:title
                                    style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action) {
                                      [self.alertController dismissViewControllerAnimated:true completion:nil];
                                  }];
}

@end
