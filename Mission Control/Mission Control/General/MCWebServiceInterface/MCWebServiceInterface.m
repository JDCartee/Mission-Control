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
//    if (!_waitingForResponse)
//    {
        NSString *parameterKey = action.urlParameterKey;
        NSString *parameterValue = action.urlParameterValue;
        NSString *stringToAppend;
        stringToAppend = [NSString stringWithFormat:@"?%@=%@",
                          parameterKey,
                          parameterValue];
//        _waitingForResponse = YES;
    
//        [delegate disableButtons];
        [self.connectionManager connectWithGetByAppendingToURL:stringToAppend];
//    }
//    else{
//        NSLog(@"Piglow command already processing.");
//    }
}

@end
