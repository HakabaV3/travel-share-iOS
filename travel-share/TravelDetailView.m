//
//  TravelDetailView.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelDetailView.h"

@interface TravelDetailView ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation TravelDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.nameLabel.frame = CGRectMake(0, height/2, width, 30);
}

- (void)setTravel:(Travel *)travel {
    self.nameLabel.text = travel.name;
}

@end
