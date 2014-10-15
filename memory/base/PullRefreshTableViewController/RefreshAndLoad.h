//
//  RefreshAndLoad.h
//  BossClient
//
//  Created by Sun on 14/7/29.
//  Copyright (c) 2014年 bossclient. All rights reserved.
//

typedef enum{
    PLPullStatePulling = 0,
    PLPullStateNormal,
    PLPullStateRefreshing,
} PLPullState;

@protocol RefreshAndLoadProtocol <NSObject>

@optional
@property (nonatomic, copy) NSString *string;

@required
@property (nonatomic, readwrite) PLPullState state;

- (void)beginRefreshing;
- (void)endRefreshing;

@end