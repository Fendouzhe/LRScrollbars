//
//  SMCommissionRecordViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommissionRecordViewController.h"
#import "SMCommisionSettlementCell2.h"
#import "SMCommissionRecordHeaderView.h"
#import "SMMonthlyBillViewController.h"
#import "LocalCommission+CoreDataProperties.h"
#import "AppDelegate.h"
#import "SMDetailOrderController.h"

@interface SMCommissionRecordViewController ()<SMCommissionRecordHeaderViewDelegate>

@property(nonatomic,copy)NSMutableArray * datasArray;

@property(nonatomic,copy)NSString * year;

@property(nonatomic,copy)NSString * month;

@property(nonatomic,copy)NSMutableDictionary * datasDic;
/**
 *  记录字典key
 */
@property(nonatomic,assign)NSInteger count;

@property(nonatomic,copy)NSString * nowmonth;

@property(nonatomic,assign)NSInteger page;

@property (nonatomic ,strong)NSArray *arrCommisions;/**< Commision * */

@end

@implementation SMCommissionRecordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"佣金纪录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //获取到当前时间
    [self getNowDate];
    
    //[self requestData];
    
    [self setupMJRefresh];
    
    [self loadSandbox];
    
    
}

-(void)getNowDate
{
    NSDate * date = [NSDate date];
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = @"yyyy-MM";
    NSString * str = [fmr stringFromDate:date];
    self.year = [str componentsSeparatedByString:@"-"][0];
    self.month = [str componentsSeparatedByString:@"-"][1];
    self.nowmonth = self.month;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 2;
    //return 1;
    return self.datasDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 5;
    //return self.datasArray.count;
    return [self.datasDic[self.datasArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCommisionSettlementCell2 *cell = [SMCommisionSettlementCell2 cellWithTableView:tableView];
    //cell.commission = self.datasArray[indexPath.row];
    NSArray * array = self.datasDic[self.datasArray[indexPath.section]];
    NSDictionary * dic = array[indexPath.row];
    Commission * comm = [Commission mj_objectWithKeyValues:dic];
    cell.commission = comm;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 *SMMatchHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMCommissionRecordHeaderView *header = [SMCommissionRecordHeaderView commissionRecordHeaderView];
    
    
    //这里可以修改头部的月份
    if (self.datasArray.count>0) {
        header.monthLabel.text = self.datasArray[section];
    }
    
    
    //判断是否 跨年
//    if (self.nowmonth.integerValue-section) {
////
//    }
//     //self.nowmonth = [NSString stringWithFormat:@"%ld",self.nowmonth.integerValue - 1];
//    
//    
//    if (self.nowmonth.integerValue-section==0) {
//        self.nowmonth = [NSString stringWithFormat:@"%ld",self.nowmonth.integerValue+12];
//    }
    
    header.delegate = self;
    
    //self.datasDic
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33 *SMMatchHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = self.datasDic[self.datasArray[indexPath.section]];
    NSString *sn = [arr[indexPath.row] objectForKey:@"sn"];
    SMDetailOrderController *vc = [[SMDetailOrderController alloc] init];
    vc.orderID = sn;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark -- SMCommissionRecordHeaderViewDelegate
- (void)monthlyBillBtnDidClick:(NSString *)year andMonth:(NSString *)month{
    SMLog(@"点击了 月账单 按钮2");
    
    SMMonthlyBillViewController *vc = [[SMMonthlyBillViewController alloc] init];
    vc.year = year;
    vc.month = month;
    [self.navigationController pushViewController:vc animated:YES];    
}

#pragma mark - 数据请求

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(NSMutableDictionary *)datasDic
{
    if (!_datasDic) {
        _datasDic = [NSMutableDictionary dictionary];
    }
    return _datasDic;
}

-(void)requestData
{
    if (!self.tableView.mj_footer.isRefreshing) {
        [self.datasArray removeAllObjects];
        [self.datasDic removeAllObjects];
    }
#pragma mark - 暂时缺少全部的接口    后面可能有全部的接口
    //改为显示2个月的。。。。
    //获取当前月份
    [self requestnet:self.year and:self.month];
    //获取前一个月
    [self monthAsc];
}

-(void)monthAsc
{
    if (self.month.integerValue==1) {
        self.month = [NSString stringWithFormat:@"%ld",self.month.integerValue+12];
        self.year = [NSString stringWithFormat:@"%ld",self.year.integerValue-1];
    }
    self.month = [NSString stringWithFormat:@"%ld",self.month.integerValue-1];
    
    [self requestnet:self.year and:self.month];
}

- (void)requestnet:(NSString *)year and:(NSString *)month
{
    [self.datasArray addObject:[NSString stringWithFormat:@"%@-%@",year,month]];
    
    [[SKAPI shared] queryCommissionByYear:year andMonth:month block:^(NSArray *array, NSError *error) {
        SMLog(@"array ==== %@",array);
//        self.datasArray  = [array mutableCopy];
        //[self.datasArray removeAllObjects];
        if (!error && array.count) {
            
            self.arrCommisions = array;
            
            NSMutableArray * mutArray = [NSMutableArray array];
            
            for (Commission * commossion in array) {
                NSDictionary * dic = [commossion mj_keyValues];
                [mutArray addObject:dic];
            }
            
            [self.datasDic setObject:mutArray forKey:[NSString stringWithFormat:@"%@-%@",year,month]];
            
            [self.tableView reloadData];
            SMLog(@"%@",self.datasDic);
            [self savesqlite];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            });

        } else {
            SMLog(@"%@",error);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        
    }];

}



#pragma mark - 缓存
-(void)savesqlite
{
    SMLog(@"save = %@",self.datasDic);
    
    [self.datasDic writeToFile:[NSString stringWithFormat:@"%@/Documents/Commission.plist",NSHomeDirectory()] atomically:YES];
}

-(void)loadSandbox
{
    [self.datasDic removeAllObjects];
    [self.datasArray removeAllObjects];
    
    NSMutableDictionary * mutdic = [[NSMutableDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/Commission.plist",NSHomeDirectory()]];
    
    for (NSString * str in [mutdic allKeys]) {
        [self.datasDic setObject:[mutdic objectForKey:str] forKey: str];
    }
    for (NSString * str in [self.datasDic allKeys]) {
        [self.datasArray addObject:str];
    }
    
    [self.tableView reloadData];
    [self requestData];
    
    
}

#pragma mark - 创建上下拉刷新
-(void)setupMJRefresh
{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNowDate];
        [self requestData];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self monthAsc];
        [self monthAsc];
    }];
    self.tableView.mj_footer = footer;
    
}
@end
 