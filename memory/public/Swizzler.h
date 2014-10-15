//
//  Swizzler.h
//  memory
//
//  Created by Sun on 14/7/28.
//
//

#import <Foundation/Foundation.h>

@interface Swizzler : NSObject

+ (void)swizzleSelector:(SEL)origS ofClass:(Class)c withSelector:(SEL)newS;

@end
