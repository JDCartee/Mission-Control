//
//  CoreDataManager.m
//  FormsinMotion
//
//  Created by Jeremy Cartee on 5/30/2014.
//  Copyright (c) 2014 Cartee. All rights reserved.
//

#import "CoreDataManager.h"
#import "FileHelper.h"

@interface CoreDataManager()

@property (nonatomic, strong) NSString *persistentStoreName;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataManager

-(id)init
{
    self = [super init];
    
    if (self)
    {
        if (!self.persistentStoreName)
        {
            self.persistentStoreName = @"store.data";
        }
        self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSString *file = [NSString stringWithFormat:@"%@.sqlite",
                          self.persistentStoreName];
        NSString *path = [FileHelper pathInLibraryDirectory:file];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        NSPersistentStore *persistentStore;
        persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                        configuration:nil
                                                                                  URL:storeURL
                                                                              options:nil
                                                                                error:&error];
        if(!persistentStore)
        {
            [NSException raise:@"Open failed"
                        format:@"Reason %@", [error localizedDescription]];
        }
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [self.managedObjectContext setUndoManager:nil];
    }
    
    return self;
}

-(id)initWithStoreName:(NSString *)storeName
{
    self = [super init];
    
    if(self)
    {
        self.persistentStoreName = storeName;
        self = [self init];
    }
    
    return self;
}

-(NSArray *)fetchEntity:(NSString *)entityKey
              sortOrder:(int)sort
                sortKey:(NSString *)sortKey
{
    BOOL sortAsc;
    
    switch (sort) {
        case sortAscending:
            sortAsc = YES;
            break;
        case sortDescending:
            sortAsc = NO;
            break;
        default:
            sortAsc = NO;
            break;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSDictionary *entities = [self.managedObjectModel entitiesByName];
    NSEntityDescription *entity = [entities objectForKey:entityKey];
    [request setEntity:entity];
    
    if (sort != sortNone)
    {
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:sortKey
                                                             ascending:sortAsc];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    }
    
    NSError *error;
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    
    return [[NSArray alloc] initWithArray:result];
}

- (id)fetchObject:(NSString *)entityName
        attribute:(NSString *)attribute
            value:(NSString *)value
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription entityForName:entityName
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"%K = %@",
                 attribute,
                 value];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];

    if (array &&
        array.count == 0)
    {
        return nil;
    }
    else if (array &&
             array.count > 0)
    {
        id objectFromArray = [array firstObject];
        return objectFromArray;
    }
    else
    {
        return nil;
    }
}

- (NSArray *)fetchObjects:(NSString *)entityName
             attribute:(NSString *)attribute
                 value:(NSString *)value
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription entityForName:entityName
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"%K = %@",
     attribute,
     value];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];
    
    return array;
}

- (NSArray *)fetchObjects:(NSString *)entityName
                Parameters:(NSMutableDictionary *)parameters
{
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate;
    NSEnumerator *enumerator = [parameters keyEnumerator];
    
    for(NSString *aKey in enumerator)
    {
        id parameter = [parameters objectForKey:aKey];
        if ([parameter isKindOfClass:[NSString class]])
        {
            predicate = [NSPredicate predicateWithFormat:@"%K = %@",
                         aKey,
                         parameter];
            [predicates addObject:predicate];
        }
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    entity = [NSEntityDescription entityForName:entityName
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *requestPreditace;
    requestPreditace = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [request setPredicate:requestPreditace];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];
    
    return array;
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    
    BOOL successful = [self.managedObjectContext save:&err];
    
    return successful;
}
@end
