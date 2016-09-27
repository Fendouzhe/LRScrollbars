//
//  CompleteOrderViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/30.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CompleteOrderViewController.h"
#import "SMOrderManagerCell.h"
#import "SMOrderHeaderView.h"
#import "SMOrderFootterView.h"
#import "SMPayViewController.h"
#import "SMStatusTrackingViewController.h"
#import "SMOrderDetailViewController.h"
#import "Product.h"
#import "SalesOrder.h"

@interface CompleteOrderViewController ()<SMOrderFootterViewDelegate>
@property (nonatomic,strong) NSArray *dataSource;/**< 数据源 */
@property (nonatomic,assign) NSInteger type;/**< 类型 */
@end

@implementation CompleteOrderViewController
-(void)setPhone:(NSString *)phone{
    _phone = [phone copy];
    MJWeakSelf
    [[SKAPI shared] queryCustomerOrderByPhone:_phone block:^(id result, NSError *error) {
        if(!error){
            [SalesOrder mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"products" : @"OrderProduct"
                         };
            }];
            NSArray *datas = [SalesOrder mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
            weakSelf.dataSource = datas;
            [weakSelf.tableView reloadData];
        }else{
            
        }
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.type = 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SalesOrder *order = self.dataSource[section];
    return [order.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMOrderManagerCell *cell = [SMOrderManagerCell cellWithTableView:tableView];
    
    SalesOrder *order = self.dataSource[indexPath.section];
//
    OrderProduct * product = order.products[indexPath.row];
//    OrderProduct * product = [self.dataSource[indexPath.section] products][indexPath.row];
    
    [cell refrshUI:product];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMOrderHeaderView* heraderView = [SMOrderHeaderView orderHeaderView];
    //头部赋值
    SalesOrder * order = self.dataSource[section];
    heraderView.orderNum.text = [NSString stringWithFormat:@"订单号:%@",order.sn];
    heraderView.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",order.createAt]];
    return heraderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SMOrderFootterView *footter = [SMOrderFootterView orderFootterView];
    footter.delegate = self;
    footter.type = self.type;
    [footter refreshUI:self.dataSource[section]];
    footter.salesOrder = self.dataSource[section];
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
    SMOrderDetailViewController *detailVc = [[SMOrderDetailViewController alloc]init];
    detailVc.salesOrder = self.dataSource[indexPath.section];
    //    detailVc.orderProduct = [self.orderArray[indexPath.section] products][indexPath.row];
    detailVc.products =  [self.dataSource[indexPath.section] products];
    
    if (self.type == 0) {//目前显示的是待付款界面
        detailVc.pushedByWaitForPay = YES;
    }else if (self.type == 3){
        detailVc.pushedByAlreadyDone = YES;
    }
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -- SMOrderFootterViewDelegate
- (void)followBtnDidClick:(SalesOrder *)salesOrder{
    SMLog(@"点击了 跟踪状态 按钮");
    if (self.type == 0) {
        SMPayViewController * payViewC = [SMPayViewController new];
        payViewC.orderStr = salesOrder.sn;
        [self.navigationController pushViewController:payViewC animated:YES];
    }else{
        SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
        trackingVc.orderString = salesOrder.sn;
        trackingVc.saleOrder = salesOrder;
        [self.navigationController pushViewController:trackingVc animated:YES];
    }
}
@end
