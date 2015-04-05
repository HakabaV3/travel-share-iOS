//
//  TravelTableViewDataSource.m
//  travel-share
//
//  Created by sho on 2015/04/04.
//  Copyright (c) 2015年 sho. All rights reserved.
//

#import "TravelTableViewDataSource.h"
#import "Travel.h"

@implementation TravelTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.travels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Travel *travel = self.travels[indexPath.row];
    cell.textLabel.text = travel.name;
    return cell;
}

@end
