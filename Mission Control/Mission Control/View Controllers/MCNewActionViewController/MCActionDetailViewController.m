//
//  MCNewActionViewController.m
//  Mission Control
//
//  Created by Jeremy Cartee on 6/7/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCActionDetailViewController.h"
#import "MCActionStore.h"

@interface MCActionDetailViewController ()

@property (nonatomic, strong) MCActionStore *actionStore;

@end

@implementation MCActionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.actionStore = [MCActionStore defaultStore];
    }
    return self;
}

- (id)initWithAction:(MCAction *)action
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.mcAction = action;
    }
    return self;
}

- (IBAction)deleteAction:(id)sender
{
    MCActionStore *actionStore = [MCActionStore defaultStore];
    if (self.mcAction)
    {
        MCAction *action = self.actionStore.currentAction;
        if ([action.actionID isEqualToString:self.mcAction.actionID])
        {
            [self.actionStore setCurrentAction:nil];
            [MCAction saveRecentAction:nil];
        }
        
        [MCAction deleteAction:self.mcAction.actionID];
        [actionStore.coreDataManager saveChanges];
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *saveActionButton;
    saveActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                     target:self
                                                                     action:@selector(saveAction)];
    [self.navigationItem setRightBarButtonItem:saveActionButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:@"Action Detail"];
    
    if (self.mcAction)
    {
        NSString *title = self.mcAction.title;
        NSString *url = self.mcAction.baseURL;
        NSString *key = self.mcAction.urlParameterKey;
        
        [self.titleTextField setText:title];
        [self.urlTextField setText:url];
        [self.parameterKeyTextField setText:key];
    }
}

- (void)saveAction
{
    NSString *title;
    title = [self.titleTextField.text isEqualToString:@""] ? nil : self.titleTextField.text;
    NSString *url;
    url = [self.urlTextField.text isEqualToString:@""] ? nil : self.urlTextField.text;
    NSString *parameterKey;
    parameterKey = [self.parameterKeyTextField.text isEqualToString:@""] ? nil : self.parameterKeyTextField.text;
    NSString *actionID;
    actionID = self.mcAction.actionID ? self.mcAction.actionID : [self.actionStore uuid];
    
    if (title &&
        url &&
        parameterKey)
    {
        if (self.mcAction.actionID)
        {
            [self.mcAction setTitle:title];
            [self.mcAction setBaseURL:url];
            [self.mcAction setUrlParameterKey:parameterKey];
        }
        else
        {
            [MCAction createAction:title
                                ID:actionID
                               URL:url
                      parameterKey:parameterKey
                    parameterValue:@""
                           timeout:70.0];
        }
        
        [self.actionStore.coreDataManager saveChanges];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
