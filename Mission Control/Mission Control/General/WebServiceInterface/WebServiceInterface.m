//
//  WebServiceInterface.m
//  Mission-Control
//
//  Created by JEREMY CARTEE on 9/9/13.
//  Copyright (c) 2013 JEREMY CARTEE. All rights reserved.
//

#import "WebServiceInterface.h"

@implementation WebServiceInterface

- (id)init
{
    return [self initWithURL:@""];
}

- (id)initWithURL:(NSString *)url
{
    self = [super init];
    if (self)
    {
        _connectionManager = [[ConnectionManager alloc] initWithURL:url];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processReturnedData:)
                                                     name:process_Connection_Data
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(connectionError:)
                                                     name:connection_Error
                                                   object:nil];
    }
    return self;
}

- (void)processReturnedData:(NSNotification *)notification
{
    NSLog(@"Process returned data notification received by base class. Make sure your class conforms to the WebServiceProtocol");
}

- (void)connectionError:(NSNotification *)notification
{
    NSLog(@"Connection notification received by base class. Make sure your class conforms to the WebServiceProtocol");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
