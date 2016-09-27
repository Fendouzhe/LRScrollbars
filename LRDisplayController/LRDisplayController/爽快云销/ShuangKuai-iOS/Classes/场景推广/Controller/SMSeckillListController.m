//
//  SMSeckillListController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSeckillListController.h"
#import "SMSeckillListCell.h"
#import "SMSeckillWebController.h"

@interface SMSeckillListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrData;/**< SMSeckill  秒杀列表 */

@end

@implementation SMSeckillListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
   
    [self.view addSubview:self.tableView];    
    
    //[self requestData];
    
//    //移除分页指示器新消息动画动画
//    [[NSNotificationCenter defaultCenter] postNotificationName:PageControlRemoveAnimationNotification object:nil userInfo:@{@"index":@"4"}];
    
    [self setupMJRefresh];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupMJRefresh{
    MJRefreshNormalHeader *TableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    self.tableView.mj_header = TableViewheader;
}

- (void)requestData{
    [[SKAPI shared] querySeckillList:10000 andLastTimestamp:-1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result querySeckillList %@",result);
            
            self.arrData = [SMSeckill mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [self.tableView reloadData];
        }else{
            SMShowErrorNet;
            SMLog(@"error   querySeckillList  %@  ",error);
        }
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)setupNav{
    self.title = @"秒杀";
    
    UIImage *image = [[UIImage imageNamed:@"问号"] scaleToSize:ScaleToSize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}

- (void)rightItemClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:@"您能在这儿获取到企业近期发布的秒杀活动，点击其中一个活动进入详情，可分享给您的好友。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    alert.view.tintColor = [UIColor redColor];
    //[action setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200 *SMMatchHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMSeckillListCell *cell = [SMSeckillListCell cellWithTableView:tableView];
    cell.model = self.arrData[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSeckillWebController *vc = [SMSeckillWebController new];
    SMSeckill *model = self.arrData[indexPath.section];
    vc.model = model;
    vc.pId = model.id;
    vc.imageUrl = model.imagePath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - LRTitleScrollViewHeight - 49 + 10 ) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate  = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
