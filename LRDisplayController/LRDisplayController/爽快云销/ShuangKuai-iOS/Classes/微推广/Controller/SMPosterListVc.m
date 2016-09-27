//
//  SMPosterListVc.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPosterListVc.h"
#import "SMPosterListCell.h"
#import "SMPosterWebVc.h"
#import "SMPosterDetailVc.h"
#import "SMPosterDetailController.h"

@interface SMPosterListVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrData;/**< SMPosterList */

@end

@implementation SMPosterListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"海报推广";
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self.view addSubview:self.tableView];

    
    //[self requestData];
    
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
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    [[SKAPI shared] queryPosterListWithCompanyId:companyId page:0 andSize:10000 andType:1 block:^(id result, NSError *error) {
        if (!error) {            
            self.arrData = (NSArray *)result;
            [self.tableView reloadData];
        }else{
            SMShowErrorNet;
            SMLog(@"error  queryPosterListWithCompanyId   %@",error);
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMPosterListCell *cell = [SMPosterListCell cellWithTableView:tableView];
    cell.model = self.arrData[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230 *SMMatchHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SMPosterList *list = self.arrData[indexPath.section];
//    SMPosterDetailVc *vc = [SMPosterDetailVc new];
//    vc.listModle = list;
//    [self.navigationController pushViewController:vc animated:YES];
//    
    SMPosterList *list = self.arrData[indexPath.section];
    
    SMPosterDetailController *detailVc = [SMPosterDetailController new];
    
    detailVc.listModle = list;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - LRTitleScrollViewHeight - 49 + 10 ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}



@end
