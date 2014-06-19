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

@property (nonatomic, strong) UIBarButtonItem *saveActionButton;

@end

@implementation MCActionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.saveActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(saveAction)];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.saveActionButton;
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveAction
{
    MCActionStore *actionStore = [MCActionStore defaultStore];
    
    NSString *title;
    title = [self.titleTextField.text isEqualToString:@""] ? nil : self.titleTextField.text;
    NSString *url;
    url = [self.urlTextField.text isEqualToString:@""] ? nil : self.urlTextField.text;
    NSString *parameterKey;
    parameterKey = [self.parameterKeyTextField.text isEqualToString:@""] ? nil : self.parameterKeyTextField.text;
    NSString *actionID;
    actionID = self.mcAction.actionID ? self.mcAction.actionID : [actionStore uuid];
    
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
        
        [actionStore.coreDataManager saveChanges];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
