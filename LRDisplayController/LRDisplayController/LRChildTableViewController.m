//
//  LRChildViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRChildTableViewController.h"
#import "LRDisplayViewHeader.h"
#import "RequesCover.h"
#import "MJRefresh.h"

@interface LRChildTableViewController ()

@property(nonatomic,strong)RequesCover *cover;

@property(nonatomic,strong)NSMutableArray *array;

@end

@implementation LRChildTableViewController
- (NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (RequesCover *)cover{
    if (_cover == nil) {
        _cover = [RequesCover requestCover];
    }
    return _cover;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
    //下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block，再这里加载最新数据
//    }];
    //或
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //上拉加载更多
        //self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block，在这里加载以前数据
        //[self loadMoreData];
        //    }];
        //或
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    });


    // 开发中可以搞个蒙版，一开始遮住当前界面，等请求成功，在把蒙版隐藏.
    //[self.view addSubview:self.cover];
    /****滚动完成请求数据*******/
    // 如果想要滚动完成或者标题点击的时候，加载数据，需要监听通知
    // 监听滚动完成或者点击标题，只要滚动完成，当前控制器就会发出通知
    // 只需要监听自己发出的，不需要监听所有对象发出的通知，否则会导致一个控制器发出，所有控制器都能监听,造成所有控制器请求数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:LRDisplayViewClickOrScrollDidFinshNotice object:self];//self 监听自己发出的
}

// 加载数据
//- (void)loadData
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSLog(@"%@--请求数据成功",self.title);
//        if (self.cover) {
//            [self.cover removeFromSuperview];
//            self.cover = nil;
//        }
//    });
//}
//设置蒙版坐标
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    self.cover.frame = self.view.bounds;
//}

- (void)loadNewData{
    [self.array addObjectsFromArray:@[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        //插到最前面显示
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.array.count)];
        [self.array insertObjects:self.array atIndexes:indexSet];
        //刷新
        [self.tableView reloadData];

    });
}
- (void)loadMoreData{
    [self.array addObjectsFromArray:@[@"8",@"8",@"8"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld",self.title,indexPath.row];
    
    return cell;
}

@end
