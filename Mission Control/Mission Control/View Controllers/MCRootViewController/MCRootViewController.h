//
//  MCRootViewController.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCWebServiceInterface.h"

@interface MCRootViewController : UIViewController <MCWebServiceInterfaceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentActionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionValueSliderTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *actionValueSlider;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitButton:(id)sender;
- (IBAction)chooseAnActionButton:(id)sender;

@end
