//
//  MCWebServiceInterface.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceInterface.h"
#import "MCAction.h"

@protocol MCWebServiceInterfaceDelegate <NSObject>

- (void)returnData:(id)data;

@end

@interface MCWebServiceInterface : WebServiceInterface

@property (nonatomic, weak) id <MCWebServiceInterfaceDelegate> delegate;
@property (nonatomic) BOOL waitingForResponse;

- (void)submitAction:(MCAction *)action;

@end
