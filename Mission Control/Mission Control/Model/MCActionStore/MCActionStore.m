//
//  MCActionStore.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCActionStore.h"

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

@end
