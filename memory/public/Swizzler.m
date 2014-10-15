//
//  Swizzler.m
//  memory
//
//  Created by Sun on 14/7/28.
//
//

#import "Swizzler.h"
#import <objc/runtime.h>

@implementation Swizzler

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)newS;
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, newS);

    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, newS, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end
