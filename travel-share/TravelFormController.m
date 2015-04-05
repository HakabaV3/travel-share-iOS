//
//  TravelFormController.m
//  travel-share
//
//  Created by sho on 2015/04/05.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelFormController.h"

#import "Travel.h"
#import "Alert.h"

@interface TravelFormController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIButton *formButton;

@end

@implementation TravelFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupView];
    [self.nameField becomeFirstResponder];
}

- (void)setupView {
    float width = self.view.frame.size.width;
    self.formButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.formButton.frame = CGRectMake(0, 120, width, 30);
    [self.formButton setBackgroundColor:[UIColor whiteColor]];
    [self.formButton setTitle:@"新規作成" forState:UIControlStateNormal];
    [self.formButton addTarget:self action:@selector(formButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.formButton];
}

#pragma mark - UIButton

- (void)formButtonAction:(UIButton *)sender {
    if (!self.nameField.hasText) {
        Alert *alert = [[Alert alloc] initWithParentViewController:self];
        [alert showWithErrorMessage:@"旅行名を入力してください。"];
        return;
    }
    
    [Travel postTravelWithName:self.nameField.text completionHandler:^(BOOL success, Travel *travel, NSError *error) {
        if (!success) {
            Alert *alert = [[Alert alloc] initWithParentViewController:self];
            [alert showWithErrorMessage:@"旅行プランの作成に失敗しました。"];
            return;
        }
        
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    float width = cell.frame.size.width;
    float height = cell.frame.size.height;
    if (indexPath.section == 0) {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
        self.nameField.keyboardType = UIKeyboardTypeDefault;
        self.nameField.returnKeyType = UIReturnKeyDone;
        self.nameField.placeholder = @"旅行名";
        self.nameField.delegate = self;
        [cell addSubview:self.nameField];
    }
    return cell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.nameField == textField) {
        [self formButtonAction:self.formButton];
    }
    return true;
}

@end
