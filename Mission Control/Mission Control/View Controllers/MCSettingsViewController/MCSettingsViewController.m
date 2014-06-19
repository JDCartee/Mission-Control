//
//  MCSettingsViewController.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCSettingsViewController.h"
#import "MCActionStore.h"
#import "MCActionDetailViewController.h"

#define MCSettingsViewControllerActionCellReuseIdentifier   @"actionCell"

@interface MCSettingsViewController ()

@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) UIBarButtonItem *addActionButton;

@end

@implementation MCSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
        self.addActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addAction)];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.addActionButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:@"Settings"];
    
    self.actions = [MCAction getActions];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section;
{
    int count = 0;
    
    if (self.actions)
    {
        count = self.actions.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *reuseIdentifier = MCSettingsViewControllerActionCellReuseIdentifier;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:reuseIdentifier];
    
    MCAction *action = [self.actions objectAtIndex:row];
    
    [cell.textLabel setText:action.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCAction *action = [self.actions objectAtIndex:indexPath.row];
    
    MCActionDetailViewController *newAction;
    newAction = [[MCActionDetailViewController alloc] initWithAction:action];
    
    [self.navigationController pushViewController:newAction
                                         animated:YES];
}

- (void)addAction
{
    MCActionDetailViewController *newAction;
    newAction = [[MCActionDetailViewController alloc] initWithNibName:nil
                                                            bundle:nil];
    [self.navigationController pushViewController:newAction
                                         animated:YES];    
}

@end
