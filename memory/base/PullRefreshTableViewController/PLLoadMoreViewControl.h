//
//  LoadMoreViewCell.h
//  PRIS_iPhone
//
//  Created by ios on 11-8-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshAndLoad.h"

@interface PLLoadMoreViewControl : UIControl <RefreshAndLoadProtocol>

- (instancetype)init;

@end
