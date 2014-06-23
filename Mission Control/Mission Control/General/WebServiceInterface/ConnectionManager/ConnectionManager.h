//
//  ConnectionManager.h
//  Mission-Control
//
//  Created by JEREMY CARTEE on 9/5/13.
//  Copyright (c) 2013 JEREMY CARTEE. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *connection_Error = @"connectionError";
static NSString *process_Connection_Data = @"processConnectionData";

@interface ConnectionManager : NSObject

@property (nonatomic, strong) NSMutableData *returnData;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) float connectionTimeout;

- (id)initWithURL:(NSString *)initURL;
- (void)connectGetWithHeaders:(NSMutableDictionary *)headers
                  andHttpBody:(NSString *)body;
- (void)connectWithGetByAppendingToURL:(NSString *)urlSuffix;
- (void)connectWithGetToURL:(NSString *)URL
                byAppending:(NSString *)urlSuffix;
@end
