//
//  MCAction.m
//  Mission Control
//
//  Created by Jeremy Cartee on 6/4/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCAction.h"
#import "MCActionStore.h"

#define MCActionRecentActionID    @"recentActionID"

@implementation MCAction

@dynamic actionID;
@dynamic title;
@dynamic baseURL;
@dynamic urlParameterKey;
@dynamic urlParameterValue;
@dynamic timeout;

+ (MCAction *) createAction:(NSString *)title
                         ID:(NSString *)actionID
                        URL:(NSString *)url
               parameterKey:(NSString *)key
             parameterValue:(NSString *)value
                    timeout:(float)timeout
{
    MCActionStore *store = [MCActionStore defaultStore];
    CoreDataManager *manager = [store coreDataManager];

    MCAction *action = [NSEntityDescription insertNewObjectForEntityForName:@"MCAction"
                                                     inManagedObjectContext:manager.managedObjectContext];
    [action setTitle:title];
    [action setActionID:actionID];
    [action setBaseURL:url];
    [action setUrlParameterKey:key];
    [action setUrlParameterValue:value];
    [action setTimeout:timeout];
    
    return action;
}

+ (void) deleteAction:(NSString *)actionID
{
    MCActionStore *store = [MCActionStore defaultStore];
    CoreDataManager *manager = [store coreDataManager];
    MCAction *action = [MCAction getActionWithID:actionID];
    
    [manager.managedObjectContext deleteObject:action];
}

+ (NSArray *) getActions
{
    MCActionStore *store = [MCActionStore defaultStore];
    CoreDataManager *manager = [store coreDataManager];
    
    NSArray *actions = [manager fetchEntity:@"MCAction"
                                  sortOrder:sortNone
                                    sortKey:nil];
    return actions;
}

+ (MCAction *)getActionWithID:(NSString *)uniqueID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    MCActionStore *store = [MCActionStore defaultStore];
    CoreDataManager *manager = [store coreDataManager];
    MCAction *returnAction;
    
    [dict setObject:uniqueID
             forKey:@"actionID"];
    
    NSArray *classResults = [manager fetchObjects:@"MCAction"
                                       Parameters:dict];
    
    if (classResults &&
        classResults.count > 0)
    {
        returnAction = [classResults firstObject];
    }
    
    return returnAction;
}

+ (MCAction *)getRecentAction
{
    NSUserDefaults *standardDefaults;
    MCAction *recentAction;
    standardDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *recentActionID = [standardDefaults stringForKey:MCActionRecentActionID];
    
    if (recentActionID)
    {
        recentAction = [self getActionWithID:recentActionID];
    }
    
    return recentAction;
}

+ (void)saveRecentAction:(MCAction *)action
{
    NSUserDefaults *standardDefaults;
    standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (action &&
        action.actionID)
    {
        [standardDefaults setObject:action.actionID
                             forKey:MCActionRecentActionID];
    }
    else if (!action)
    {
        [standardDefaults setObject:@""
                             forKey:MCActionRecentActionID];
    }
    
    [standardDefaults synchronize];
}

@end
