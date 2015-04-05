//
//  ViewController.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelListController.h"
#import "TravelTableViewDataSource.h"

#import "TravelDetailController.h"
#import "TravelFormController.h"
#import "SettingController.h"

#import "Travel.h"

#import "Alert.h"
#import "LoginManager.h"

@interface TravelListController ()<UITableViewDelegate>

@property (nonatomic, strong) TravelTableViewDataSource *datasource;

@end

@implementation TravelListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datasource = [[TravelTableViewDataSource alloc] init];
    self.tableView.dataSource = self.datasource;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    [self refreshTravelList];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNaviItems];
}

- (void)createNaviItems {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Setting"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"new"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    SettingController *settingController = [[SettingController alloc] initWIthIsLogin:[[LoginManager sharedManager] isLogin]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:settingController];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    TravelFormController *formController = [[TravelFormController alloc] init];
    [self.navigationController pushViewController:formController animated:true];
}

#pragma mark - UIRefreshControl

- (void)onRefresh:(id)sender {
    [self refreshTravelList];
}

- (void)refreshTravelList {
    [self.refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *userId = [[LoginManager sharedManager] userId];
    [Travel getTravelListWithUserId:userId completionHandler:^(BOOL success, NSArray *travels, NSError *error) {
        [self.refreshControl endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!success) {
            Alert *alert = [[Alert alloc] initWithParentViewController:self];
            [alert showWithErrorMessage:@"旅行プランの取得に失敗しました。"];
            return;
        }
        self.datasource.travels = travels;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Travel *travel = self.datasource.travels[indexPath.row];
    TravelDetailController *travelDetailController = [[TravelDetailController alloc] initwithTravel:travel];
    [self.navigationController pushViewController:travelDetailController animated:YES];
}


@end
