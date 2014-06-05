//
//  MCAction.h
//  Mission Control
//
//  Created by Jeremy Cartee on 6/4/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCAction : NSManagedObject

@property (nonatomic, retain) NSString * actionID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * baseURL;
@property (nonatomic, retain) NSString * urlParameterKey;
@property (nonatomic, retain) NSString * urlParameterValue;

@end
