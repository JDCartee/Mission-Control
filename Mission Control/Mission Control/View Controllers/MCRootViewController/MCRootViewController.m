//
//  MCRootViewController.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCRootViewController.h"
#import "MCSettingsViewController.h"
#import "MCActionStore.h"
#import "MCWebServiceInterface.h"
#import "ConnectionManager.h"

const float navigationItemSettingsButtonWidth =                 30.0f;
const float navigationItemSettingsButtonHeight =                30.0f;
const float navigationItemSettingsButtonFontSize =              36.0f;

@interface MCRootViewController ()

@property (nonatomic, strong) MCActionStore *actionStore;
// Making this weak because the store singleton will ultimately retain this object.
// No need to own it here.
@property (nonatomic, weak) MCAction *currentActionFromStore;
@property (nonatomic, strong) MCWebServiceInterface *webService;
@property (nonatomic, strong) UIWebView *responseWebView;

@end

@implementation MCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        self.actionStore = [MCActionStore defaultStore];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBarButtons];
    [self setupCurrentAction];
    [self setupActionSlider];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setupResponseTextView];
    if (self.currentActionFromStore)
    {
    }
}

#pragma mark IBActions

- (IBAction)submitButton:(id)sender
{
    [self.responseWebView loadHTMLString:nil
                                 baseURL:nil];
    [self.actionStore networkActivityIndicatorShow];
    [self.submitButton setEnabled:NO];
    [self.webService submitAction:self.currentActionFromStore];
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
    MCSettingsViewController *settings;
    settings = [[MCSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:settings
                                         animated:YES];
}

#pragma Current Action

- (void)setupCurrentAction
{
    NSString *value;
    self.currentActionFromStore = self.actionStore.currentAction;
    if (self.currentActionFromStore)
    {
        value = self.currentActionFromStore.urlParameterValue;
        if (value)
        {
            NSString *valueLabelString = [NSString stringWithFormat:@"Value: %@",
                                          value];
            [self.actionValueSliderTitleLabel setText:valueLabelString];
            [self.actionValueSlider setValue:value.floatValue
                                    animated:YES];
        }
        else
        {
            [self updateActionValue];
        }
        [self.currentActionTitleLabel setText:self.currentActionFromStore.title];
        [self.currentActionLabel setText:self.currentActionFromStore.baseURL];
    }
    else
    {
        [self updateActionValue];
    }
    
    [self refreshwebService];
}

#pragma mark Slider

- (void)setupActionSlider
{
    [self.actionValueSlider addTarget:self
                               action:@selector(updateActionValue)
                     forControlEvents:UIControlEventValueChanged];
}

- (void)updateActionValue
{
    NSString *valueString = [NSString stringWithFormat:@"%d",
                             (int)self.actionValueSlider.value];
    NSString *valueLabelString = [NSString stringWithFormat:@"Value: %@",
                                  valueString];
    
    [self.currentActionFromStore setUrlParameterValue:valueString];
    [self.actionValueSliderTitleLabel setText:valueLabelString];
}

#pragma mark Response Text View

- (void)setupResponseTextView
{
    CGRect webViewFrame = CGRectMake(0,
                                     0,
                                     self.actionContainerView.frame.size.width,
                                     self.actionContainerView.frame.size.height);
    self.responseWebView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [self.actionContainerView addSubview:self.responseWebView];
}

#pragma mark Web Service

- (void)returnData:(id)data
{
    if (data)
    {
        ConnectionManager *conn = data;
        NSString *returnData;
        returnData = [[[NSString alloc] initWithData:conn.returnData encoding:NSASCIIStringEncoding] copy];
        [self.responseWebView loadHTMLString:returnData baseURL:[NSURL URLWithString:self.currentActionFromStore.baseURL]];
    }
    [self refreshwebService];
    [self.actionStore networkActivityIndicatorHide];
    [self.submitButton setEnabled:YES];
}

- (void)refreshwebService
{
    self.webService = nil;
    NSString *baseURL = self.currentActionFromStore.baseURL;
    self.webService = [[MCWebServiceInterface alloc] initWithURL:baseURL];
    [self.webService setDelegate:self];
}

@end
