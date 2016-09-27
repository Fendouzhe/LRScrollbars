//
//  SMSuccessOrFailViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSuccessOrFailViewController.h"
#import "SMOrderDetailViewController.h"
#import "AppDelegate.h"

@interface SMSuccessOrFailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paySuccessLabel;

@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *PayOrderLable;
@property (weak, nonatomic) IBOutlet UILabel *certainOrderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *PayTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property(nonatomic,strong)SalesOrder * salesOrder;
@end

@implementation SMSuccessOrFailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:238/255.0 blue:237/255.0 alpha:1];
    //设置btn的layer
    self.title = @"付款成功";
    self.orderDetailBtn.backgroundColor = KRedColorLight;
    self.backBtn.backgroundColor = KRedColorLight;
    
    self.orderDetailBtn.layer.cornerRadius = SMCornerRadios;
    self.orderDetailBtn.layer.masksToBounds = YES;
    self.backBtn.layer.cornerRadius = SMCornerRadios;
    self.backBtn.layer.masksToBounds = YES;
    self.moneyLable.textColor = KRedColorLight;
    self.paySuccessLabel.textColor = KRedColorLight;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
}
///订单详情
- (IBAction)orderBtnAction:(UIButton *)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    // 查看订单 跳转
    SMOrderDetailViewController * detail = [SMOrderDetailViewController new];
    //给一个orderSn
    detail.salesOrder = self.salesOrder;
    detail.pushedByAlreadyDone = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
///返回首页
- (IBAction)backUserAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)setOrderString:(NSString *)orderString
{
    _orderString = orderString;
    
    [[SKAPI shared] queryOrder:orderString block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result = %@",result);
            
            self.salesOrder = (SalesOrder *)result;
            
            [self refreshUI:self.salesOrder];
        }else{
            
            SMLog(@"%@",error);
        }
    }];
}

-(void)refreshUI:(SalesOrder *)order
{
    self.consigneeLabel.text = [NSString stringWithFormat:@"收货人:%@ %@",order.buyerName,order.buyerPhone];
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",order.buyerAddress];
    self.moneyLable.text = [NSString stringWithFormat:@"￥%.2f",order.realPayMoney];
    self.orderLable.text = [NSString stringWithFormat:@"订单编号:%@",order.sn];
    //这个怎么获得？？？
    if (self.payWay == nil) {
        self.payWay = @"";
    }
    self.PayOrderLable.text = [NSString stringWithFormat:@"%@交易号:%@",self.payWay,order.transactionNo];
    SMLog(@"order.transactionNo  %@",order.transactionNo);
    
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    
    fmr.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:order.createAt];
    
    NSString * str1 = [fmr stringFromDate:date1];
    
    self.certainOrderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",str1];
    
    NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:order.payTime];
    
    NSString * str2 = [fmr stringFromDate:date2];
    
    self.PayTimeLabel.text = [NSString stringWithFormat:@"付款时间:%@",str2];
    
}

@end
