//
//  AppDelegate.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "AppDelegate.h"
#import "TravelListController.h"
#import "LoginManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setLoginManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TravelListController *mainController = [[TravelListController alloc] init];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:mainController];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setLoginManager {
    [[LoginManager sharedInstance] me:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"\n未ログイン");
        }
        NSLog(@"\nログイン済み");
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
