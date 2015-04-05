//
//  ViewController.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelListController.h"
#import "Notifications.h"

#import "TravelTableViewDataSource.h"
#import "TravelDetailController.h"
#import "SettingController.h"

#import "Travel.h"
#import "LoginManager.h"

@interface TravelListController ()<UITableViewDelegate>

@property (nonatomic, strong) TravelTableViewDataSource *datasource;

@end

@implementation TravelListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessGetShopList:) name:SuccessGetTravelList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFailureGetShopList:) name:FailureGetTravelList object:nil];
    
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
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    SettingController *settingController = [[SettingController alloc] initWIthIsLogin:[[LoginManager sharedInstance] isLogin]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:settingController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - NSNotification

- (void)onSuccessGetShopList:(NSNotification *)notificationCenter {
    NSArray *travels = [[notificationCenter userInfo] objectForKey:@"travels"];
    self.datasource.travels = travels;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)onFailureGetShopList:(NSNotification *)notificationCenter {
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UIRefreshControl

- (void)onRefresh:(id)sender {
    [self refreshTravelList];
}

- (void)refreshTravelList {
    [self.refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [Travel getTravelList];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Travel *travel = self.datasource.travels[indexPath.row];
    TravelDetailController *travelDetailController = [[TravelDetailController alloc] initwithTravel:travel];
    [self.navigationController pushViewController:travelDetailController animated:YES];
}


@end
