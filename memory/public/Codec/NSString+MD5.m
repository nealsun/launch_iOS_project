//
//  NSString+MD5.m
//  memory
//
//  Created by Sun on 13-7-3.
//  Copyright (c) 2013年 orz. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSData *)MD5:(NSStringEncoding)encode {
    NSData *data = [self dataUsingEncoding:encode allowLossyConversion:NO];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    unsigned long l = strlen(cStr);
    CC_MD5( data.bytes, data.length, digest ); // This is the md5 call
    return [[NSData alloc] initWithBytes:digest length: sizeof digest];
}

- (id)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

@end
