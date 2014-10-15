//
//  RefreshTableHeaderView.h
//  ipad_reader
//
//  Created by reed zhu on 10-12-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshAndLoad.h"

@interface PLTableRefreshControl : UIControl <RefreshAndLoadProtocol>

- (instancetype)init;

@end