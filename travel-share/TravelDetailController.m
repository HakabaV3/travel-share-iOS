//
//  TravelDetailController.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelDetailController.h"
#import "TravelDetailView.h"

@interface TravelDetailController ()

@property (nonatomic, strong) Travel *travel;

@end

@implementation TravelDetailController

- (instancetype)initwithTravel:(Travel *)travel {
    if (self == [super init]) {
        self.travel = travel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TravelDetailView *travelDetailView = [[TravelDetailView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:travelDetailView];
}

@end
