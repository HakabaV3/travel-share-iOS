//
//  AuthNewController.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "SignUpController.h"

#import "Alert.h"
#import "LoginManager.h"

@interface SignUpController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userIdField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *signupButton;

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupView];
}

- (void)setupView {
    self.signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.signupButton.frame = CGRectMake(0, 190, self.view.frame.size.width, 30);
    [self.signupButton setBackgroundColor:[UIColor whiteColor]];
    [self.signupButton setTitle:@"新規作成" forState:UIControlStateNormal];
    [self.signupButton addTarget:self action:@selector(onSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.signupButton];
}

#pragma mark - UIButton

- (void)onSignUpButton:(UIButton *)sender {
    if (!self.userIdField.hasText || !self.userNameField.hasText || !self.passwordField.hasText) {
        Alert *alert = [[Alert alloc] initWithParentViewController:self];
        [alert showWithErrorMessage:@"必須事項を入力してください。"];
        return;
    }

    NSString *userId = self.userIdField.text;
    NSString *userName = self.userNameField.text;
    NSString *password = self.passwordField.text;
    LOG(@"\nID: %@\nName: %@\npassword: %@", userId, userName, password);
    [[LoginManager sharedInstance] signupWithId:userId userName:userName password:password completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            Alert *alert = [[Alert alloc] initWithParentViewController:self];
            [alert showWithErrorMessage:@"ユーザーIDは既に使用されています。"];
            return;
        }
        
        [[LoginManager sharedInstance] loginWithId:userId password:password completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                Alert *alert = [[Alert alloc] initWithParentViewController:self];
                [alert showWithErrorMessage:@"ログインに失敗しました。"];
                return;
            }
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        self.userIdField.placeholder = @"ユーザーID";
        self.userIdField.delegate = self;
        [cell addSubview:self.userIdField];
    } else if (indexPath.row == 1){
        self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
        self.userNameField.keyboardType = UIKeyboardTypeAlphabet;
        self.userNameField.returnKeyType = UIReturnKeyNext;
        self.userNameField.placeholder = @"ユーザー名";
        self.userNameField.delegate = self;
        [cell addSubview:self.userNameField];
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
        [self.userNameField becomeFirstResponder];
        
    } else if (self.userNameField == textField) {
        [self.userNameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
        
    } else if (self.passwordField == textField) {
        [self onSignUpButton:self.signupButton];
        
    }
    return true;
}


@end
