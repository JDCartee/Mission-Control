//
//  MCRootViewController.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCWebServiceInterface.h"

@interface MCRootViewController : UIViewController
<MCWebServiceInterfaceDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIGestureRecognizerDelegate>

/**
 Current action URL label
 */
@property (weak, nonatomic) IBOutlet UILabel *currentActionLabel;
/**
 Current action title label
 */
@property (weak, nonatomic) IBOutlet UILabel *currentActionTitleLabel;
/**
 Action value label
 */
@property (weak, nonatomic) IBOutlet UILabel *actionValueSliderTitleLabel;
/**
 Action value slider
 */
@property (weak, nonatomic) IBOutlet UISlider *actionValueSlider;
/**
 Action container for picker and result web view
 */
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;
/**
 Submit button for initiating current action
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitButton:(id)sender;
- (IBAction)chooseAnActionButton:(id)sender;

@end
