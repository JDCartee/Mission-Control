//
//  MCWebServiceInterface.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCWebServiceInterface.h"
#import "MCAction.h"

@implementation MCWebServiceInterface

- (void)submitAction:(MCAction *)action
{
    if (!self.waitingForResponse)
    {
        NSString *parameterKey = action.urlParameterKey;
        NSString *parameterValue = action.urlParameterValue;
        NSString *stringToAppend;
        stringToAppend = [NSString stringWithFormat:@"?%@=%@",
                          parameterKey,
                          parameterValue];
        [self setWaitingForResponse:YES];
    
        [self.connectionManager setConnectionTimeout:40.0];
        [self.connectionManager connectWithGetByAppendingToURL:stringToAppend];
    }
    else
    {
        NSLog(@"Command already processing.");
    }
}

- (void)processReturnedData:(NSNotification *)notification
{
    self.waitingForResponse = NO;
    NSLog(@"returned data from MCInterface");
    if ([self.delegate respondsToSelector:@selector(returnData:)])
    {
        [self.delegate performSelector:@selector(returnData:)
                            withObject:notification.object];
    }
}

- (void)connectionError:(NSNotification *)notification
{
    NSLog(@"error from MCInterface");
    self.waitingForResponse = NO;
    if ([self.delegate respondsToSelector:@selector(returnData:)])
    {
        [self.delegate performSelector:@selector(returnData:)
                            withObject:nil];
    }
}

@end
