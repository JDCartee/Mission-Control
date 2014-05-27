//
//  MCRootViewController.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCRootViewController.h"

const float navigationItemSettingsButtonWidth =                 30.0f;
const float navigationItemSettingsButtonHeight =                30.0f;
const float navigationItemSettingsButtonFontSize =              36.0f;

@interface MCRootViewController ()

@end

@implementation MCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBarButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)submitButton:(id)sender
{
}

- (IBAction)chooseAnActionButton:(id)sender
{
}

#pragma mark Navigation Controller

- (void)setupNavBarButtons
{
    UIBarButtonItem *settingsButton;
    settingsButton = [self settingsButton];
    [self.navigationItem setRightBarButtonItem:settingsButton];
}

- (UIBarButtonItem *)settingsButton
{
    UIButton *barButton;
    UILabel *gearLabel;
    NSString *gear = @"\u2699";
    UIBarButtonItem *settingsButton;
    
    CGRect buttonRect = CGRectMake(0,
                                   0,
                                   navigationItemSettingsButtonWidth,
                                   navigationItemSettingsButtonHeight);
    CGRect gearRect = CGRectMake(0,
                                 0,
                                 navigationItemSettingsButtonWidth,
                                 navigationItemSettingsButtonHeight);
    gearLabel = [[UILabel alloc] initWithFrame:gearRect];
    gearLabel.font = [UIFont fontWithName:@"Helvetica"
                                     size:navigationItemSettingsButtonFontSize];
    gearLabel.text = gear;

    barButton = [[UIButton alloc] initWithFrame:buttonRect];
    [barButton addSubview:gearLabel];
    [barButton addTarget:self
                  action:@selector(openSettings)
        forControlEvents:UIControlEventTouchUpInside];
    
    settingsButton = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    return settingsButton;
}

- (void)openSettings
{
    
}
@end
