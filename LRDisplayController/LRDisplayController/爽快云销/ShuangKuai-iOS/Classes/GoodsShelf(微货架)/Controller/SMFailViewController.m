//
//  SMFailViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMFailViewController.h"
#import "AppDelegate.h"

@interface SMFailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderLable;

@property (weak, nonatomic) IBOutlet UILabel *certainOrderTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *PayTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *againPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation SMFailViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置btn的layer
    self.againPayBtn.layer.cornerRadius = 10;
    self.againPayBtn.layer.masksToBounds = YES;
    self.backBtn.layer.cornerRadius = 10;
    self.backBtn.layer.masksToBounds = YES;
    self.againPayBtn.backgroundColor = KRedColorLight;
    self.backBtn.backgroundColor = KRedColorLight;
    self.title = @"付款失败";
    
}

- (IBAction)againPayAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backUser:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)setOrderstring:(NSString *)orderstring
{
    _orderstring = orderstring;
    
    [[SKAPI shared] queryOrder:orderstring block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"%@",result);
            
            SalesOrder * order = (SalesOrder *)result;
            
            [self refreshUI:order];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)refreshUI:(SalesOrder *)order
{
    self.consigneeLabel.text = [NSString stringWithFormat:@"收货人:%@ %@",order.buyerName,order.buyerPhone];
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",order.buyerAddress];
    self.orderLable.text = [NSString stringWithFormat:@"订单编号:%@",self.orderstring];
    
    
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    
    fmr.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:order.createAt];
    
    NSString * str = [fmr stringFromDate:date];
    
    self.certainOrderTimeLable.text = [NSString stringWithFormat:@"下单时间:%@",str];
    if (order.payTime == 0) {
      self.PayTimeLabel.text = [NSString stringWithFormat:@"付款时间:暂未付款"];
    }else{
        self.PayTimeLabel.text = [NSString stringWithFormat:@"付款时间:%ld",order.payTime];
    }
    
}
@end
