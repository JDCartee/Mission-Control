//
//  MCNewActionViewController.h
//  Mission Control
//
//  Created by Jeremy Cartee on 6/7/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAction.h"

@interface MCActionDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *parameterKeyTextField;

@property (nonatomic, strong) MCAction *mcAction;

- (id)initWithAction:(MCAction *)action;
- (IBAction)deleteAction:(id)sender;

@end
