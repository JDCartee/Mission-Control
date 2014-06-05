//
//  FileHelper.h
//
//  Created by Jeremy Cartee on 5/30/2014.
//  Copyright (c) 2014 Cartee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(NSString *)pathInDocumentDirectory:(NSString *)fileName;
+(NSString *)documentDirectory;
+(NSString *)pathInLibraryDirectory:(NSString *)fileName;
+(NSString *)libraryDirectory;

@end