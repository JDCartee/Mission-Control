//
//  WebServiceInterface.h
//  Mission-Control
//
//  Created by JEREMY CARTEE on 9/9/13.
//  Copyright (c) 2013 JEREMY CARTEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"

@protocol WebServiceProtocol <NSObject>

-(void) processReturnedData:(NSNotification *)notification;
-(void) connectionError:(NSNotification *)notification;

@end

@interface WebServiceInterface : NSObject

@property (nonatomic, strong) ConnectionManager *connectionManager;

- (id)initWithURL:(NSString *)url;

@end
