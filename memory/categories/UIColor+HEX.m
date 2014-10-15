//
//  UIColor+HEX.m
//  memory
//
//  Created by neal on 14/10/16.
//  Copyright (c) 2014年 orz. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor (HEX)

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(float)alpha {
    CGFloat red = ((hex & 0x0FF0000)>>16)/255.0;
    CGFloat green = ((hex & 0x0FF00)>>8)/255.0;
    CGFloat blue = (hex & 0xFF)/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
