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

/**
 Default initilizer for the root view controller
 @param nibNameOrNil
    NSString - Nib name
 @param nibBundleOrNil
    NSBundle - Nib bundle
 @returns self
    id - self
 */
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

/**
 View load sets up nav bar, current action, and the action slider
 @brief View load
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBarButtons];
    [self setupCurrentAction];
    [self setupActionSlider];
}

/**
 View will appear sets up response web view and title
 @brief View will appear
 @param animated
    BOOL - animate
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:@"Mission Control"];
    
    [self.actionStore getActions];
}

/**
 View did appear sets up current action
 @brief View did appear
 @param animated
    BOOL - animate
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currentActionFromStore)
    {
        [self setupCurrentAction];
    }
    else
    {
        [self removeCurrentAction];
    }
}

#pragma mark IBActions

/**
 Submit action button to initiate the defined service call action
 @brief Submit the current action
 @param sender
    id - button
 @returns IBaction
 */
- (IBAction)submit:(id)sender
{
    [self removePicker];
    [self setupResponseWebView];
    [self.responseWebView loadHTMLString:nil
                                 baseURL:nil];
    [self.actionStore networkActivityIndicatorShow];
    [self.submitButton setEnabled:NO];
    [self.chooseAnActionButton setEnabled:NO];
    [self.webService submitAction:self.currentActionFromStore];
}

/**
 Sets up the action picker to allow the user to choose and action
 @brief Choose an action
 @param sender
    id - button
 @returns IBAction
 */
- (IBAction)chooseAnAction:(id)sender
{
    [self.actionPicker removeFromSuperview];
    [self.responseWebView removeFromSuperview];
    
    if (self.actionStore.actions &&
        self.actionStore.actions.count > 0)
    {
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
    
}

#pragma mark Navigation Controller

/**
 Set up the nav bar buttons for the root view controller
 @brief Set up nav bar buttons
 */
- (void)setupNavBarButtons
{
    UIBarButtonItem *settingsButton;
    settingsButton = [self settingsButton];
    [self.navigationItem setRightBarButtonItem:settingsButton];
}

/**
 Settings bar button for creating and modifying actions
 @brief Settings bar button
 @returns settingsButton
    UIBarButton
 */
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

/**
 Selector for settings button to bring up the settings view controller for creatings and 
 modifying actions
 @brief Selector for settings button
 */
- (void)openSettings
{
    MCSettingsViewController *settings;
    settings = [[MCSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:settings
                                         animated:YES];
}

#pragma mark Current Action

/**
 Get the current action from the action store and set it up on the root view controller
 @brief Set up the current action
 */
- (void)setupCurrentAction
{
    NSString *value;
    [self setCurrentActionFromStore:self.actionStore.currentAction];
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

/**
 Removes the current action from the root view
 @brief Remove the current action
 */
- (void)removeCurrentAction
{
    [self setCurrentActionFromStore:nil];
    [self updateActionValue];
    [self.currentActionTitleLabel setText:@""];
    [self.currentActionLabel setText:@""];
    [self.responseWebView removeFromSuperview];
}

#pragma mark Slider

/**
 Set up action slider to capture action values
 @brief Set up action slider
 */
- (void)setupActionSlider
{
    [self.actionValueSlider addTarget:self
                               action:@selector(updateActionValue)
                     forControlEvents:UIControlEventValueChanged];
}

/**
 Action slider change selector for modifying the curent action value
 @brief Action slider change selector
 */
- (void)updateActionValue
{
    NSString *valueString = [NSString stringWithFormat:@"%d",
                             (int)self.actionValueSlider.value];
    NSString *valueLabelString = [NSString stringWithFormat:@"Value: %@",
                                  valueString];
    
    if (self.currentActionFromStore)
    {
        [self.currentActionFromStore setUrlParameterValue:valueString];
    }
    
    [self.actionValueSliderTitleLabel setText:valueLabelString];
}

#pragma mark Response Text View

/**
 Set up the response web view to display the result of service calls
 @brief Set up the response web view
 */
- (void)setupResponseWebView
{
    CGRect webViewFrame = CGRectMake(0,
                                     0,
                                     self.actionContainerView.frame.size.width,
                                     self.actionContainerView.frame.size.height);
    [self.responseWebView removeFromSuperview];
    self.responseWebView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [self.actionContainerView addSubview:self.responseWebView];
}

#pragma mark Web Service

/**
 Present the returned data in the response web view.
 @brief Present returned data
 @param data
    id - returned data
 */
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
    [self.chooseAnActionButton setEnabled:YES];
}

/**
 Refresh the web service object
 @brief  Refresh the web service object
 */
- (void)refreshwebService
{
    NSString *baseURL = self.currentActionFromStore.baseURL;
    self.webService = [[MCWebServiceInterface alloc] initWithURL:baseURL];
    [self.webService setDelegate:self];
}

#pragma mark Pickerview Datasource
/**
 Sets up the number of components in the action picker view
 @brief Number of action picker components
 @param pickerView
    UIPickerView - action picker view
 @returns NSInteger
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

/**
 Number of action rows in the action picker
 @brief Number of actions
 @param pickerView
    UIPickerView - Action picker view
 @param component
    NSInteger - component number
 @returns count
    NSInteger - Number of actions
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;
{
    NSInteger count = 0;
    NSArray *actions = [MCAction getActions];
    
    if (actions)
    {
        count = actions.count;
    }
    
    return count;
}

/**
 Title for action picker view row
 @brief Title for action picker view row
 @param pickerView
    UIPickerView - Action picker
 @param row
    NSInteger - Action picker view row
 @param component
    NSInteger - components
 @returns actionTitle
    NSString - Row title
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component;
{
    NSArray *actions = [self.actionStore getActions];
    NSString *actionTitle = @"";
    
    if (actions)
    {
        MCAction *action = [actions objectAtIndex:row];
        actionTitle = action.title;
    }
    
    return actionTitle;
}

/**
 Remove the action picker
 @brief Remove the action picker
 */
- (void)removePicker
{
    [self.actionPicker removeGestureRecognizer:self.pickerGesture];
    [self.actionPicker removeFromSuperview];
}

#pragma mark Pickerview Delegate

/**
 Set up the tap gesture recognizer on the action picker for selecting an action
 @brief Set up the tap gesture recognizer on the action picker
 */
- (void)setupTapGestureOnPicker
{
    self.pickerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(pickerTapped:)];
    [self.pickerGesture setDelegate:self];
    [self.actionPicker addGestureRecognizer:self.pickerGesture];
}

/**
 Tap gesture recognizer selector for the action picker view
 @brief Tap gesture recognizer selector for the action picker view
 @param gestureRecognizer
    UIGestureRecognizer - tap gesture recognizer
 */
- (void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self removePicker];
    [self setupResponseWebView];
}

/**
 Picker view did select action row
 @brief Did select action row
 @param pickerView
    UIPickerView - Action picker
 @param row
    NSInteger - Action picker view row
 @param component
    NSInteger - components
 */
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

/**
 Should recognize simultaneous gesture recognizers
 @brief Should recognize simultaneous gesture recognizers
 @param gestureRecognizer
    UIGestureRecognizer - gesture recognizer
 @param otherGestureRecognizer
    UIGestureRecognizer - other gesture recognizer
 @returns BOOL - should recognize simultaneous gestures
 */
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

/**
 Select the current action in the action picker
 @brief Select the current action
 */
- (void)selectCurrentAction
{
    MCAction *action = self.currentActionFromStore;
    NSArray *actions = self.actionStore.actions;
    
    NSInteger row = 0;
    
    if (action)
    {
        row = [actions indexOfObject:action];
    }

    if (actions)
    {
        [self.actionPicker selectRow:row
                         inComponent:0
                            animated:NO];
        [self pickerView:self.actionPicker
            didSelectRow:row
             inComponent:0];
    }
}

@end
