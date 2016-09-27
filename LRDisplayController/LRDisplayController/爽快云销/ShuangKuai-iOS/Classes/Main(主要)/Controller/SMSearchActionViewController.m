//
//  SMSearchActionViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchActionViewController.h"
#import "SMLeftItemBtn.h"
#import "SMSearchBar.h"
#import "SMScanerBtn.h"
#import "SMSynthesizeBtn.h"
#import "SMProductCollectionViewCell.h"
#import "SMAllProductTableViewCell.h"
#import "SMAllActionTableViewCell.h"
#import "SMDetailStoreHouseController.h"
#import "SMDiscountDetailController.h"
#import "SMActionViewController.h"
#import "SMScannerViewController.h"
#import "SMPersonCenterViewController.h"
#import "SMSearchViewController.h"
#import "SMShelfDiscountCell.h"
#import "SMProductDetailController.h"
#import "SMProductClassesController.h"

#import <MagicalRecord/MagicalRecord.h>
#import "LocalStorehouse+CoreDataProperties.h"
#import "LocalActivity+CoreDataProperties.h"
#import "LocalCoupon+CoreDataProperties.h"
#import "Reachability.h"
#import "SMRightItemView.h"


#define KCollectionViewCell @"productCollectionViewCell"
@interface SMSearchActionViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView * actionTableView;
/**
 *  全部活动的数据
 */
@property (nonatomic ,copy)NSMutableArray *dataActions;

/**
 *  活动的页码
 */
@property(nonatomic,assign)NSInteger actionPage;



@end

@implementation SMSearchActionViewController

-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动";

    [self.view addSubview:self.actionTableView];
    
    [self SetupMJRefresh];

    self.actionPage = 1;

    [self loadNewDataActions];
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.dataActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        SMAllActionTableViewCell *cell = [SMAllActionTableViewCell cellWithTableView:tableView];
        Activity *action = self.dataActions[indexPath.row];
    
        cell.action = action;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    
        if (isIPhone5) {
            height = 155;
        }else if (isIPhone6){
            height = 155 *KMatch6;
        }else if (isIPhone6p){
            height = 155 *KMatch6p;
        }

    return height;
    //
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.actionTableView){
        SMLog(@"点击了全部活动下的cell %zd",indexPath.row);
        SMActionViewController *actionVc = [[SMActionViewController alloc] init];
        //模型赋值
        Activity *activity = self.dataActions[indexPath.row];
        actionVc.activity = activity;
        [self.navigationController pushViewController:actionVc animated:YES];
    }
}

- (NSMutableArray *)dataActions{
    if (_dataActions == nil) {
        _dataActions = [NSMutableArray array];
    }
    return _dataActions;
}


- (UITableView *)actionTableView{
    if (_actionTableView == nil) {
        _actionTableView = [[UITableView alloc] init];
        _actionTableView.dataSource = self;
        _actionTableView.delegate = self;
        _actionTableView.frame = CGRectMake(0,0, KScreenWidth, KScreenHeight - KStateBarHeight);
        _actionTableView.hidden = NO;
        _actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _actionTableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark - MJRefresh

-(void)SetupMJRefresh
{
    MJRefreshNormalHeader *activitytableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.actionPage = 1;
        [self loadNewDataActions];
        //self.actionTableView.mj_footer.hidden = NO;
    }];
    self.actionTableView.mj_header = activitytableviewtheader;
    MJRefreshAutoNormalFooter *activitytableviewfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.actionPage++;
        [self loadNewDataActions];
    }];
    self.actionTableView.mj_footer = activitytableviewfooter;
}

/**
 *  加载活动tableView的新数据
 */
- (void)loadNewDataActions{
    //获取公司id
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    [[SKAPI shared] queryActivityByCompanyId:Id andKeyword:self.keyWord andIsRecommend:YES andPage:self.actionPage andSize:10 block:^(NSArray *array, NSError *error) {
            
            if (!error) {
                if (!self.actionTableView.mj_footer.isRefreshing) {
                    [self.dataActions removeAllObjects];
                }
                if (array.count>0) {
                    for (Activity * activity in array) {
                        [self.dataActions addObject:activity];
                    }
                    [self.actionTableView reloadData];
                    
                    [self.actionTableView.mj_header endRefreshing];
                    [self.actionTableView.mj_footer endRefreshing];
                }else
                {
                    [self.actionTableView.mj_footer endRefreshingWithNoMoreData];
                    [self.actionTableView reloadData];
                }
            }else{
                SMLog(@"%@",error);
                
                [self.actionTableView.mj_header endRefreshing];
                [self.actionTableView.mj_footer endRefreshing];
            }
        }];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.actionTableView.mj_header endRefreshing];
//        [self.actionTableView.mj_footer endRefreshing];
//    });
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        alertView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

@end
