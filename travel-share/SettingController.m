//
//  SettingController.m
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "SettingController.h"
#import "SignInController.h"
#import "SignUpController.h"

#import "Alert.h"
#import "LoginManager.h"

@interface SettingController ()<UITableViewDataSource, UITableViewDelegate>

@property BOOL isLogin;

@end

@implementation SettingController

- (instancetype)initWIthIsLogin:(BOOL)isLogin {
    if (self == [self init]) {
        self.isLogin = isLogin;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createNaviItems];
}

- (void)createNaviItems {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isLogin ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isLogin) {
        switch (section) {
            case 0: return 1;
            case 1: return 1;
            default: break;
        }
    } else {
        switch (section) {
            case 0: return 1;
            case 1: return 2;
            case 2: return 1;
            default: break;
        }
    }
    return 0;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (!self.isLogin) {
            SignInController *signinController = [[SignInController alloc] init];
            [self.navigationController pushViewController:signinController animated:true];
            return;
        }
        Alert *alert = [[Alert alloc] initWithParentViewController:self];
        [alert showWithLogoutMessage];
    }
    
    if (section == 1 && !self.isLogin) {
        SignUpController *signupController = [[SignUpController alloc] init];
        [self.navigationController pushViewController:signupController animated:true];
    }
    
    if (section == 2) {
        Alert *alert = [[Alert alloc] initWithParentViewController:self];
        [alert showWithResignMessage];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (!self.isLogin) {
            cell.textLabel.text = @"ログイン";
        } else {
            cell.textLabel.text = @"ログアウト";
        }
    }
    
    if (section == 1) {
        if (!self.isLogin) {
            cell.textLabel.text = @"アカウント作成";
            return cell;
        }
        
        if (row == 0) {
            cell.textLabel.text = [[LoginManager sharedInstance] userId];
        } else if (row == 1) {
            cell.textLabel.text = [[LoginManager sharedInstance] userName];
        }
    }
    
    if (section == 2) {
        cell.textLabel.text = @"退会";
    }
    
    return cell;
}


@end
