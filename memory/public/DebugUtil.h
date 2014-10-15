//
//  DebugUtil.h
//  memory
//  used for debuging， swizzle framework‘s selector
//  Created by neal on 14/10/8.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Swizzler.h"

#ifndef DEBUG
@interface UIScrollView (Debug)

@end

@implementation UIScrollView (Debug)

//+ (void)load {
//    [Swizzler swizzleSelector:@selector(setContentOffset:) ofClass:[UIScrollView class] withSelector:@selector(mk_setContentOffset:)];
//}

- (void)mk_setContentOffset:(CGPoint)offset {
    return;
    [self mk_setContentOffset:offset];
    if (offset.x == 0) {
        DLog(@"");
    }
}
@end
#endif