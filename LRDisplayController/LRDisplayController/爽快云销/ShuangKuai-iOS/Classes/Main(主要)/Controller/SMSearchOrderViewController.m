//
//  SMSearchOrderViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchOrderViewController.h"
#import "SMOrderManagerCell.h"
#import "SMOrderHeaderView.h"
#import "SMOrderFootterView.h"
#import "SMStatusTrackingViewController.h"
#import "SMOrderDetailViewController.h"
#import "LocalSalesOrder.h"
#import "SMPayViewController.h"


@interface SMSearchOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SMOrderFootterViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

/**
 *  刷新用的页码
 */
@property(nonatomic,assign)NSInteger page;

/**
 *  数据保存数组
 */
@property(nonatomic,copy)NSMutableArray * orderArray;

@property(nonatomic,assign)NSInteger type;

@end

@implementation SMSearchOrderViewController

#pragma mark - 懒加载
-(NSMutableArray *)orderArray
{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.page = 1;
    self.type = -1;
    //创建tableview
    [self creatTableView];
    
    [self setupMJRefresh];
    
    [self requestData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotice) name:@"orderRefresh" object:nil];
}
-(void)refreshNotice
{
    [self requestData];
}

-(void)creatTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(49);
    }];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.orderArray[section] products] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMOrderManagerCell *cell = [SMOrderManagerCell cellWithTableView:tableView];
    
    OrderProduct * product = [self.orderArray[indexPath.section] products][indexPath.row];
    [cell refrshUI:product];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMOrderHeaderView* heraderView = [SMOrderHeaderView orderHeaderView];
    //头部赋值
    SalesOrder * order = self.orderArray[section];
    heraderView.orderNum.text = [NSString stringWithFormat:@"订单号:%@",order.sn];
    heraderView.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",order.createAt]];
    return heraderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SMOrderFootterView *footter = [SMOrderFootterView orderFootterView];
    footter.delegate = self;
    SalesOrder * order = self.orderArray[section];
    footter.type = order.status;
    [footter refreshUI:self.orderArray[section]];
    return footter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 82;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMOrderDetailViewController *detailVc = [[SMOrderDetailViewController alloc] init];
    detailVc.salesOrder = self.orderArray[indexPath.section];
    //    detailVc.orderProduct = [self.orderArray[indexPath.section] products][indexPath.row];
    detailVc.products =  [self.orderArray[indexPath.section] products];
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -- SMOrderFootterViewDelegate
- (void)followBtnDidClick:(NSString * )sn andStatus:(NSInteger)status{
    SMLog(@"点击了 跟踪状态 按钮");
    //两种  一种是重新付款，一种是物流状态
    if (status == 0) {
        //重新支付
        SMPayViewController  * pay  =[SMPayViewController new];
        pay.orderStr = sn;
        [self.navigationController pushViewController:pay animated:YES];
    }else{
        //物流状态
        SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
        trackingVc.orderString = sn;
        [self.navigationController pushViewController:trackingVc animated:YES];
    }
    
}

#pragma mark - 创建上下拉刷新
-(void)setupMJRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self requestData];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestData];
    }];
    self.tableView.mj_footer = footer;
}


-(void)requestData
{
    [[SKAPI shared] queryOrderBySn:self.keyWord andStatus:self.type andPage:self.page andSize:20 block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            SMLog(@"array = %@",array);
            if (array.count>0) {
                if (!self.tableView.mj_footer.isRefreshing) {
                    [self.orderArray removeAllObjects];
                }
                for (SalesOrder * order in array) {
                    [self.orderArray addObject:order];
                }
                
                SMLog(@"%@",self.orderArray);
                [self.tableView reloadData];
                
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }else
            {   [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}
@end



