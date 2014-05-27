//
//  MCRootViewController.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCRootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *currentActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentActionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionValueSliderTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *actionValueSlider;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;

- (IBAction)submitButton:(id)sender;
- (IBAction)chooseAnActionButton:(id)sender;

@end
