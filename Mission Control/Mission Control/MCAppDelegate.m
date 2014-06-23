//
//  MCAppDelegate.m
//  Mission Control
//
//  Created by Jeremy Cartee on 5/26/14.
//  Copyright (c) 2014 Jeremy Cartee. All rights reserved.
//

#import "MCAppDelegate.h"
#import "MCRootViewController.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MCRootViewController *rootViewController;
    rootViewController = [[MCRootViewController alloc] initWithNibName:nil
                                                                bundle:nil];
    UINavigationController *nav;
    nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self.window setRootViewController:nav];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
