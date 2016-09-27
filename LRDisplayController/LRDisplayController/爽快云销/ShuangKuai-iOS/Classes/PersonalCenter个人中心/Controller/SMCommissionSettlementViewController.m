//
//  SMCommissionSettlementViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.

//   佣金结算

#import "SMCommissionSettlementViewController.h"
#import "SMCommisionSettlementCell.h"
#import "SMCommisionSettlementCell1.h"
#import "SMCommisionSettlementCell2.h"
#import "SMOrderDetailFootterView.h"
#import "SMCommissionExtractionViewController.h"
#import "SMExtractionRecordViewController.h"
#import "SMSettlementSectionHeaderView.h"
#import "SMCommissionRecordViewController.h"
#import "SMBoundCardViewController.h"
#import "SMDetailOrderController.h"
#import "AppDelegate.h"

@interface SMCommissionSettlementViewController ()<SMSettlementSectionHeaderViewDelegate,SMSettlementSectionHeaderViewDelegate>

@property(nonatomic,copy)NSMutableArray * commissionArray;

@property(nonatomic,copy)NSDictionary * resultDic;
/**
 *  本月销售额   sumPrice
 */
@property (nonatomic ,copy)NSString *totalCommision;
/**
 *  本月佣金   sumCommission
 */
@property (nonatomic ,copy)NSString *currentMonthCommision;
/**
 *  上月佣金  lastSumCommission
 */
@property (nonatomic ,copy)NSString *lastMonthCommision;


@property (nonatomic ,copy)NSString *waitForCheck;/**< 待审核  sumApplMoney0*/

@property (nonatomic ,copy)NSString *canGive;/**< 可发放  sumApplMoney1*/


/**
 *  最近收入
 */
@property (nonatomic ,strong)NSArray *arrIncome;

@end

@implementation SMCommissionSettlementViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
//    [self requestCommissionDatas];
//    [self requestTop];
    
    [self getData];
    
    //最近收入
    [self recentIncome];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  最近收入   Status：0等待付款，1已付款，2已发货，3已完成，4已关闭, -1 不关状态的事，所有状态  ,-2 除掉未付款和已关闭的订单
 */
- (void)recentIncome{
    [[SKAPI shared] queryOrderBySn:@"" andStatus:-2 andPage:1 andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrIncome = array;
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)getData{
    [[SKAPI shared] queryCommission:^(id result, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)result[@"result"];
            SMLog(@"dict   queryCommission   %@",dict);
            
            self.totalCommision = [NSString stringWithFormat:@"%.2lf",[dict[@"sumPrice"] doubleValue]];
            self.currentMonthCommision = [NSString stringWithFormat:@"%.2lf",[dict[@"sumCommission"] doubleValue]];
            self.lastMonthCommision = [NSString stringWithFormat:@"%.2lf",[dict[@"lastSumCommission"] doubleValue]];
            self.waitForCheck = [NSString stringWithFormat:@"%.2lf",[dict[@"sumApplMoney0"] doubleValue]];
            self.canGive = [NSString stringWithFormat:@"%.2lf",[dict[@"sumApplMoney1"] doubleValue]];
            
            SMLog(@"self.totalCommision   %@, self.currentMonthCommision  %@,  self.lastMonthCommision  %@",self.totalCommision,self.currentMonthCommision,self.lastMonthCommision);
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)setupNav{
    self.title = @"佣金结算";
    
    UIButton *rightBtn = [[UIButton alloc] init];
//    rightBtn.width = 60;
//    rightBtn.height = 25;
//        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontMiddleMatch;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"佣金记录" attributes:dict];
    
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        //return 5;
        return self.arrIncome.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//第0组
        if (indexPath.row == 0) {//第0行
            SMCommisionSettlementCell *cell = [SMCommisionSettlementCell cellWithTableView:tableView];
            //cell.totalCommisionLabel.text = [NSString stringWithFormat:@"%@",self.resultDic[@"current_commission"]];
            
            cell.totalsalesLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.totalCommision doubleValue]];
            cell.auditCommissionLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.waitForCheck doubleValue]];
            cell.hasCommissionLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.canGive doubleValue]];
            return cell;
        }else{//第1行
            SMCommisionSettlementCell1 *cell = [SMCommisionSettlementCell1 cellWithTableView:tableView];
            [cell refreshUI:[self.resultDic copy]];
            
            cell.nowMonthLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.currentMonthCommision doubleValue]];
            cell.lastMonthLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.lastMonthCommision doubleValue]];
            return cell;
        }
    }else{//第1组
        SMCommisionSettlementCell2 *cell = [SMCommisionSettlementCell2 cellWithTableView:tableView];
        cell.order = self.arrIncome[indexPath.row];
        
        if (self.commissionArray.count>0) {
            cell.commission = self.commissionArray[indexPath.row];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//第0组
        if (indexPath.row == 0) {
            return 75 *SMMatchHeight;
        }else{
            return 88 *SMMatchHeight + 1;
        }
    }else{//第1组
        return 60 *SMMatchHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
//        SMOrderDetailFootterView *header = [SMOrderDetailFootterView orderDetailFootterView];
//        header.titleLabel.text = @"物流状态";
//        header.titleLabel.textColor = [UIColor blackColor];
        
        SMSettlementSectionHeaderView *header = [SMSettlementSectionHeaderView settlementSectionHeaderView];
        header.delegate = self;
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 30 *SMMatchHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        SMLog(@"用户点了  佣金提取");
#pragma mark --  这里要判断用户有没有绑定过银行卡，如果没有绑定银行卡，就给一个提示框alertView 并跳转到 绑定银行卡的界面，如果有绑定银行卡，才跳到佣金提取界面
        //绑定银行卡的接口还没写，这个要等接口出来再接数据
        
//        SMCommissionExtractionViewController *vc = [[SMCommissionExtractionViewController alloc] init];
//        // 获取用户的银行卡
//        vc.money = self.resultDic[@"current_commission"];
//        
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        SalesOrder *order = self.arrIncome[indexPath.row];
        NSString *Id = order.id;
        SMDetailOrderController *vc = [[SMDetailOrderController alloc] init];
        vc.orderID = Id;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}
#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 提取记录 按钮");
//    SMExtractionRecordViewController *recordVc = [[SMExtractionRecordViewController alloc] init];
//    [self.navigationController pushViewController:recordVc animated:YES];
    
    SMCommissionRecordViewController *recordVc = [[SMCommissionRecordViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:recordVc animated:NO];
}

#pragma mark -- SMSettlementSectionHeaderViewDelegate
- (void)commissionBtnDidClick{
    SMLog(@"点击了 佣金纪录 按钮2");
    SMCommissionRecordViewController *recordVc = [[SMCommissionRecordViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:recordVc animated:YES];
}


#pragma mark - 佣金简单记录数据
-(NSMutableArray *)commissionArray
{
    if (!_commissionArray) {
        _commissionArray = [NSMutableArray array];
    }
    return _commissionArray;
}
-(NSDictionary *)resultDic
{
    if (!_resultDic) {
        _resultDic = [NSDictionary dictionary];
    }
    return _resultDic;
}

-(void)requestCommissionDatas
{
    NSDate *date = [NSDate date];
    NSDateFormatter * fmr = [NSDateFormatter new];
    fmr.dateFormat = [NSString stringWithFormat:@"yyyy"];
    NSString * year = [fmr stringFromDate:date];
    fmr.dateFormat = [NSString stringWithFormat:@"MM"];
    NSString * month = [fmr stringFromDate:date];
    SMLog(@"year  %@  month  %@",year,month);
#pragma mark - 暂时没有数据 
    [[SKAPI shared ] queryCommissionByYear:@"2016" andMonth:@"03" block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            for (Commission * commission in array) {
                [self.commissionArray addObject:commission];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void)requestTop
{
    [[SKAPI shared] queryCommissionProfile:^(id result, NSError *error) {
        SMLog(@"haha%@",result);
        self.resultDic = [NSDictionary dictionaryWithDictionary:result];
        SMLog(@"%@",self.resultDic);
        [self.tableView reloadData];
    }];
}

@end
