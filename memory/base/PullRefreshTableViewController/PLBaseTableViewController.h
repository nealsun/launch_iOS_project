//
//  PLBaseTableTableViewController.h
//  PetLove4IOS
//
//  Created by Sun on 14-4-9.
//  Copyright (c) 2014年 petlove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORZBaseTableViewController.h"
#import "PLTableRefreshControl.h"
#import "PLLoadMoreViewControl.h"

@interface PLBaseTableViewController : ORZBaseTableViewController <UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, strong) PLTableRefreshControl *refreshControl;
@property (nonatomic, strong) PLLoadMoreViewControl *loadMoreControl;

@end
