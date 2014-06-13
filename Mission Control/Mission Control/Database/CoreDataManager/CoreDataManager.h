//
//  CoreDataManager.h
//  FormsinMotion
//
//  Created by Jeremy Cartee on 5/30/2014.
//  Copyright (c) 2014 Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileHelper.h"

#define sortNone          0
#define sortAscending     1
#define sortDescending    2

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSArray *)fetchEntity:(NSString *)entityKey
               sortOrder:(int)sort
                 sortKey:(NSString *)sortKey;
- (id)fetchObject:(NSString *)entityName
        attribute:(NSString *)attribute
            value:(NSString *)value;
- (NSArray *)fetchObjects:(NSString *)entityName
                attribute:(NSString *)attribute
                    value:(NSString *)value;
- (NSArray *)fetchObjects:(NSString *)entityName
               Parameters:(NSMutableDictionary *)parameters;
- (BOOL)saveChanges;

@end
