//
//  MCActionStore.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCActionStore.h"
#import "FileHelper.h"

#define kMCActionStoreSavedActionTitleKey                     @"savedActionTitle"
#define kMCActionStoreSavedActionBaseURLKey                   @"savedActionBaseURL"
#define kMCActionStoreSavedActionUrlParameterKeyKey           @"savedActionUrlParameterKey"
#define kMCActionStoreSavedActionParameterValueKey            @"savedActionUrlParameterValue"


static MCActionStore *_mainInstance;

@interface MCActionStore()

@property UIApplication *app;

@end

@implementation MCActionStore

+ (instancetype)defaultStore
{
    static dispatch_once_t once;
    if (_mainInstance == nil)
    {
        dispatch_once(&once, ^
        {
            _mainInstance = [[MCActionStore alloc] init];
        });
    }
    return _mainInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.app = [UIApplication sharedApplication];
        if (!self.coreDataManager)
        {
            self.coreDataManager = [[CoreDataManager alloc] init];
        }
    }
    return self;
}

- (void)networkActivityIndicatorShow
{
    [self.app setNetworkActivityIndicatorVisible:YES];
}

- (void)networkActivityIndicatorHide
{
    [self.app setNetworkActivityIndicatorVisible:NO];
}

- (void)restoreRecentAction
{
    self.currentAction = [MCAction getRecentAction];
}

- (NSString *)uuid
{
    NSString *uuidString;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}

- (NSArray *)getActions
{
    NSArray *databaseActions = [MCAction getActions];
    self.actions = [[NSArray arrayWithArray:databaseActions] copy];
    databaseActions = nil;
    return  self.actions;
}


@end
