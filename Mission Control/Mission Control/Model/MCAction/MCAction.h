//
//  MCAction.h
//  Mission Control
//
//  Created by Jeremy Cartee on 5/27/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCAction : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *urlParameterKey;
@property (nonatomic, strong) NSString *urlParameterValue;

- (instancetype)initWithBaseURL:(NSString *)url
                  withParameter:(NSString *)parameter
                        ofTitle:(NSString *)title;

@end
