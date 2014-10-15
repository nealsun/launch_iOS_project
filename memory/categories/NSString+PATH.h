//
//  NSString+PATH.h
//  memory
//
//  Created by Sun on 14-4-25.
//  Copyright (c) 2014年 orz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PATH)

+ (BOOL)touch:(NSString *)path;

/**
 return Library/Caches
 */
+ (NSString *)cachePath;

/**
 return Library
 */
+ (NSString *)libraryPath;

/**
 return Library/Application Support
 */
+ (NSString *)applicationSupportPath;

/**
 return Documents
 */
+ (NSString*)documentPath;

/**
 Library/ImageCaches
 */
+ (NSString *)imageCachesPath;

@end
