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
#import "MCAction.h"

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

@property (nonatomic, strong) UIPickerView *actionPicker;
@property (nonatomic, strong) UITapGestureRecognizer *pickerGesture;
@property (nonatomic) NSInteger currentActionPickerRow;

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
        [self.actionStore restoreRecentAction];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupResponseTextView];
    [self setTitle:@"Mission Control"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currentActionFromStore)
    {
        [self setupCurrentAction];
    }
}

#pragma mark IBActions

- (IBAction)submitButton:(id)sender
{
    [self removePicker];
    [self setupResponseTextView];
    [self.responseWebView loadHTMLString:nil
                                 baseURL:nil];
    [self.actionStore networkActivityIndicatorShow];
    [self.submitButton setEnabled:NO];
    [self.webService submitAction:self.currentActionFromStore];
}

- (IBAction)chooseAnActionButton:(id)sender
{
    [self.actionPicker removeFromSuperview];
    [self.responseWebView removeFromSuperview];
    self.responseWebView = nil;
    float width = self.actionContainerView.frame.size.width;
    float height = self.actionContainerView.frame.size.height;
    CGRect pickerRect = CGRectMake(0,
                                   0,
                                   width,
                                   height);
    self.actionPicker = [[UIPickerView alloc] initWithFrame:pickerRect];
    [self.actionPicker setDataSource:self];
    [self.actionPicker setDelegate:self];
    [self.actionContainerView addSubview:self.actionPicker];
    [self setupTapGestureOnPicker];
    [self selectCurrentAction];
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

#pragma mark Current Action

- (void)setupCurrentAction
{
    NSString *value;
    [self setCurrentActionFromStore:self.actionStore.currentAction ];
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
        returnData = [[[NSString alloc] initWithData:conn.returnData
                                            encoding:NSASCIIStringEncoding] copy];
        [self.responseWebView loadHTMLString:returnData
                                     baseURL:[NSURL URLWithString:self.currentActionFromStore.baseURL]];
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

#pragma mark Pickerview Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;
{
    NSInteger count;
    NSArray *actions = [MCAction getActions];
    
    count = actions.count;
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component;
{
    NSArray *actions = [self.actionStore getActions];
    
    MCAction *action = [actions objectAtIndex:row];
    NSString *actionTitle = action.title;
    
    return actionTitle;
}

- (void)removePicker
{
    [self.actionPicker removeGestureRecognizer:self.pickerGesture];
    [self.actionPicker removeFromSuperview];
}

#pragma mark Pickerview Delegate

- (void)setupTapGestureOnPicker
{
    self.pickerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(pickerTapped:)];
    [self.pickerGesture setDelegate:self];
    [self.actionPicker addGestureRecognizer:self.pickerGesture];
}

- (void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self removePicker];
    [self setupResponseTextView];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    self.currentActionPickerRow = row;
    NSArray *actions = [self.actionStore getActions];
    MCAction *action = [actions objectAtIndex:self.currentActionPickerRow];
    [self.actionStore setCurrentAction:action];
    [self setupCurrentAction];
    [MCAction saveRecentAction:action];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] &&
        [otherGestureRecognizer isKindOfClass:UITapGestureRecognizer.class])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)selectCurrentAction
{
    MCAction *action = self.currentActionFromStore;
    NSArray *actions = self.actionStore.actions;
    
    NSInteger row = [actions indexOfObject:action];
    
    [self.actionPicker selectRow:row
                     inComponent:0
                        animated:NO];
}

@end
