//
//  FileHelpers.m
//  DigitalAirWare
//
//  Created by Jeremy Cartee on 2/17/12.
//  Copyright (c) 2012 Cartee. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

#pragma mark -Document Directory

+ (NSString *)pathInDocumentDirectory:(NSString *)fileName
{
    NSArray *documentDirectories;
    documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentDirectory
{
    NSArray *documentDirectories;
    documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
    
    return [documentDirectories objectAtIndex:0];
}

#pragma mark - Library Directory

+ (NSString *)pathInLibraryDirectory:(NSString *)fileName
{
    NSArray *libraryDirectories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                      NSUserDomainMask,
                                                                      YES);
    
    NSString *libraryDirectory = [libraryDirectories objectAtIndex:0];
    
    return [libraryDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)libraryDirectory
{
    NSArray *libraryDirectories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                      NSUserDomainMask,
                                                                      YES);
    
    return [libraryDirectories objectAtIndex:0];
}

@end
