//
//  NSString+PATH.m
//  memory
//
//  Created by Sun on 14-4-25.
//  Copyright (c) 2014年 orz. All rights reserved.
//

#import "NSString+PATH.h"

@implementation NSString (PATH)

+ (BOOL)touch:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}

	return YES;
}

+ (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)applicationSupportPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	return paths[0];
}

+ (NSString*)documentPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return paths[0];
}

+ (NSString *)imageCachesPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * path = [paths[0] stringByAppendingFormat:@"/ImageCaches"];
    [self touch:path];
    return path;
}

@end