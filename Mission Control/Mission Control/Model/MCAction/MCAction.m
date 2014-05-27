//
//  MCAction.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCAction.h"

@implementation MCAction

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)url
                  withParameter:(NSString *)parameter
                        ofTitle:(NSString *)title
{
    self = [self init];
    if (self)
    {
        self.baseURL = url;
        self.urlParameterKey = parameter;
        self.title = title;
    }
    return self;
}

@end
