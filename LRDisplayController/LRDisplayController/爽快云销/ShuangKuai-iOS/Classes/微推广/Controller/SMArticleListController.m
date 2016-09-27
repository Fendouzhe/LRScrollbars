//
//  SMArticleListController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMArticleListController.h"
#import "SMPosterListCell.h"
#import "SMArticleWebController.h"
#import "SMArticalList.h"
#import "SMArticalListCell.h"

@interface SMArticleListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrData;/**< SMPosterList */

@end

@implementation SMArticleListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章推广";
    
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
    [[SKAPI shared] queryArticleListWithCompanyId:companyId page:0 andSize:10000 block:^(id result, NSError *error) {
        if (!error) {
            //SMLog(@"result   queryPosterListWithCompanyId  %@",result);
            self.arrData = [SMArticalList mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"result"]];
            
            [self.tableView reloadData];
        }else{
            SMShowErrorNet;
            SMLog(@"error  queryPosterListWithCompanyId   %@",error);
        }
        [self.tableView.mj_header endRefreshing];
    }];
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.arrData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMArticalListCell *cell = [SMArticalListCell cellWithTableView:tableView];
    cell.model = self.arrData[indexPath.row];
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
    
    SMLog(@"indexPath.section   %zd",indexPath.section);
    SMArticalList *list = self.arrData[indexPath.section];
    
    SMArticleWebController *vc = [SMArticleWebController new];
    vc.listModle = list;
    [self.navigationController pushViewController:vc animated:YES];
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
