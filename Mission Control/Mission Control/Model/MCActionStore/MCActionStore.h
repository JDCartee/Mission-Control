//
//  MCActionStore.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCAction.h"

@interface MCActionStore : NSObject

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, strong) MCAction *currentAction;

+ (instancetype)defaultStore;

- (void)networkActivityIndicatorShow;
- (void)networkActivityIndicatorHide;

@end
