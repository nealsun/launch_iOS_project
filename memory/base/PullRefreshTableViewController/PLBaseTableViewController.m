//
//  PLBaseTableTableViewController.m
//  PetLove4IOS
//
//  Created by Sun on 14-4-9.
//  Copyright (c) 2014年 petlove. All rights reserved.
//

#import "PLBaseTableViewController.h"

@interface PLBaseTableViewController ()

@end

@implementation PLBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - 
#pragma mark var
- (void)setRefreshControl:(PLTableRefreshControl *)refreshControl {
    [_refreshControl removeFromSuperview];
    _refreshControl = refreshControl;
    [self.tableView addSubview:_refreshControl];
}

- (void)setLoadMoreControl:(PLLoadMoreViewControl *)loadMoreControl {
    _loadMoreControl = loadMoreControl;
    self.tableView.tableFooterView = _loadMoreControl;
}
#pragma mark -
#pragma mark datasource action
- (void)refreshDataSource {
//    [self.dataSource refresh];

    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:4];
}

- (void)loadMore {
//    [self.dataSource loadMore];

    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:4];
}

#pragma mark -
#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
