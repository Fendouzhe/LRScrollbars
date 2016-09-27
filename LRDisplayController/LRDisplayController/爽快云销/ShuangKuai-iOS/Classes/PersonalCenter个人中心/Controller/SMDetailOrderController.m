//
//  SMDetailOrderController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailOrderController.h"

@interface SMDetailOrderController ()
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
/**
 *  成交时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dealTime;
/**
 *  付款时间
 */
@property (weak, nonatomic) IBOutlet UILabel *payTime;
/**
 *  发货时间
 */
@property (weak, nonatomic) IBOutlet UILabel *sendGoodsTime;
/**
 *  应付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mustPayMoney;
/**
 *  实付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
/**
 *  佣金总额
 */
@property (weak, nonatomic) IBOutlet UILabel *totalCommision;

//间隔线
@property (weak, nonatomic) IBOutlet UIView *grayView0;
@property (weak, nonatomic) IBOutlet UIView *grayView2;
@property (weak, nonatomic) IBOutlet UIView *grayView3;
@property (weak, nonatomic) IBOutlet UIView *grayVIew4;
@property (weak, nonatomic) IBOutlet UIView *grayView5;
@property (weak, nonatomic) IBOutlet UIView *grayView6;
@property (weak, nonatomic) IBOutlet UIView *grayView7;


@end

@implementation SMDetailOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"佣金详情";
    
    [self setupGrayViews];
    
    [self getOrderInfo];
    

}

- (void)setupGrayViews{
    self.grayView0.backgroundColor = KGrayColorSeparatorLine;
    self.grayView2.backgroundColor = KGrayColorSeparatorLine;
    self.grayView3.backgroundColor = KGrayColorSeparatorLine;
    self.grayVIew4.backgroundColor = KGrayColorSeparatorLine;
    self.grayView5.backgroundColor = KGrayColorSeparatorLine;
    self.grayView6.backgroundColor = KGrayColorSeparatorLine;
    self.grayView7.backgroundColor = KGrayColorSeparatorLine;
}

- (void)getOrderInfo{
//    [[SKAPI shared] queryOrderBySn:self.orderID andStatus:-1 andPage:1 andSize:10 block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            SMLog(@"array   %@  self.orderID  %@", array ,self.orderID);
//            for (SalesOrder *order in array) {
//                SMLog(@"order.id   %@    self.orderID   %@",order.id,self.orderID);
//            }
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
    
    [[SKAPI shared] queryOrder:self.orderID block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"[result class]    %@",[result class]);
            [self setupDataWithModel:result];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)setupDataWithModel:(SalesOrder *)order{
    
    self.orderNum.text = order.sn;
    self.dealTime.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",order.createAt]];
    if (order.payTime) {
        self.payTime.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",order.payTime]];
    }else{
        self.payTime.text = nil;
    }
    
    //发货时间要先判断状态，如果状态是0，则显示未发货。
    SMLog(@"order.status  %zd   order.sendTime %zd",order.status,order.sendTime);
    if (order.status == 0) {
        self.sendGoodsTime.text = @"未发货";
    }else if(order.sendTime){
        self.sendGoodsTime.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",order.sendTime]];
    }else if (!order.sendTime){
        self.sendGoodsTime.text = nil;
    }
    self.mustPayMoney.text = [NSString stringWithFormat:@"%.2f",order.sumPrice];
    self.payMoney.text = [NSString stringWithFormat:@"%.2f",order.realPayMoney];
    self.totalCommision.text = [NSString stringWithFormat:@"%.2f",order.sumCommission];
}

@end
