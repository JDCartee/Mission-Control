//
//  MCActionStore.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCAction.h"
#import "CoreDataManager.h"

@interface MCActionStore : NSObject

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, strong) MCAction *currentAction;
@property (nonatomic, strong) CoreDataManager *coreDataManager;

+ (instancetype)defaultStore;

- (void)networkActivityIndicatorShow;
- (void)networkActivityIndicatorHide;
- (void)restoreRecentAction;
- (NSString *)uuid;
- (NSArray *)getActions;

@end
