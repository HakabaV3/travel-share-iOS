//
//  AuthController.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "SignInController.h"
#import "SignUpController.h"

#import "Alert.h"
#import "LoginManager.h"


@interface SignInController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userIdField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation SignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.userIdField becomeFirstResponder];
}

- (void)setupView {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.frame = CGRectMake(0, 140, self.view.frame.size.width, 30);
    [self.loginButton setBackgroundColor:[UIColor whiteColor]];
    [self.loginButton setTitle:@"ログイン" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.loginButton];
    
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signupButton.frame = CGRectMake(0, 180, self.view.frame.size.width, 30);
    [signupButton setBackgroundColor:[UIColor whiteColor]];
    [signupButton setTitle:@"アカウントを作成していない方" forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(onSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:signupButton];
}

#pragma mark - UIButton

- (void)onLoginButton:(UIButton *)sender {
    if (!self.userIdField.hasText || !self.passwordField.hasText) {
        Alert *alert = [[Alert alloc] initWithParentViewController:self];
        [alert showWithErrorMessage:@"ユーザーIDとパスワードを入力してください。"];
        return;
    }
    
    NSString *userId = self.userIdField.text;
    NSString *password = self.passwordField.text;
    [[LoginManager sharedManager] loginWithId:userId password:password completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            Alert *alert = [[Alert alloc] initWithParentViewController:self];
            [alert showWithErrorMessage:@"ユーザーIDまたはパスワードに誤りがあります。"];
            return;
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)onSignUpButton:(UIButton *)sender {
    SignUpController *signupController = [[SignUpController alloc] init];
    [self.navigationController pushViewController:signupController animated:true];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    float width = cell.frame.size.width;
    float height = cell.frame.size.height;
    if (indexPath.row == 0) {
        self.userIdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
        self.userIdField.keyboardType = UIKeyboardTypeAlphabet;
        self.userIdField.returnKeyType = UIReturnKeyNext;
        self.userIdField.placeholder = @"User ID";
        self.userIdField.delegate = self;
        [cell addSubview:self.userIdField];
    } else {
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
        self.passwordField.keyboardType = UIKeyboardTypeAlphabet;
        self.passwordField.returnKeyType = UIReturnKeyDone;
        self.passwordField.placeholder = @"パスワード";
        self.passwordField.delegate = self;
        self.passwordField.secureTextEntry = true;
        [cell addSubview:self.passwordField];
    }
    return cell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.userIdField == textField) {
        [self.userIdField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    } else if (self.passwordField == textField) {
        [self onLoginButton:self.loginButton];
    }
    return true;
}

@end
