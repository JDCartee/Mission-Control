//
//  MCSettingsViewController.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCSettingsViewController.h"

@implementation MCSettingsViewController

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:nil];
    
    [cell.textLabel setText:@"Action"];
    return cell;
}

@end
