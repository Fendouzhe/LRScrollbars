//
//  SMOrderFootterView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderFootterView.h"
#import "SalesOrder.h"

@interface SMOrderFootterView ()


@property (weak, nonatomic) IBOutlet UIView *grayLine;

@property (weak, nonatomic) IBOutlet UIView *grayLine1;
@property (strong, nonatomic) IBOutlet UIButton *logisticsBtn;

@property (nonatomic,copy)NSString * orderString;

@property (weak, nonatomic) IBOutlet UIView *grayLine0;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view0H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2H;


@end

@implementation SMOrderFootterView

- (void)awakeFromNib{
    self.productNumLabel.textColor = KRedColorLight;
    self.totalPriceLabel.textColor = KRedColorLight;
    self.CommissionLabel.textColor = KRedColorLight;
    self.followStauteBtn.backgroundColor = KRedColorLight;
    self.underGrayView.backgroundColor = KControllerBackGroundColor;
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
    self.grayLine1.backgroundColor = KGrayColorSeparatorLine;
    self.grayLine0.backgroundColor = KGrayColorSeparatorLine;
    self.followStauteBtn.layer.cornerRadius = 4;
    self.followStauteBtn.layer.masksToBounds = YES;
    
    self.view0H.constant = 36 *SMMatchHeight;
    self.view1H.constant = 36 *SMMatchHeight;
    self.view2H.constant = 36 *SMMatchHeight;
}

+ (instancetype)orderFootterView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMOrderFootterView" owner:nil options:nil] lastObject];
}

- (IBAction)followBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(followBtnDidClick:)]) {
        [self.delegate followBtnDidClick:self.salesOrder];
    }
    
    if ([self.delegate respondsToSelector:@selector(followBtnDidClick:andStatus:)]) {
        [self.delegate followBtnDidClick:self.orderString andStatus:self.type];
    }
}

//不知道数据字段
-(void)FootterWithOrder:(NSString *)order andTimer:(NSString *)timer
{
   
}

#pragma mark - 刷新UI
-(void)refreshUI:(SalesOrder *)order
{
    self.followStauteBtn.hidden = NO;
    SMLog(@"order.status   %zd",order.status);
    if (order.status == 0) {//待付款
        [self.followStauteBtn setTitle:@"重新付款" forState:UIControlStateNormal];
        self.followStauteBtn.userInteractionEnabled = YES;
        self.followStauteBtn.hidden = NO;
    }else if(order.status == 1){//已付款(待发货)
        [self.followStauteBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        self.followStauteBtn.userInteractionEnabled = YES;
        self.followStauteBtn.hidden = NO;
    }else if(order.status == 2 || order.status == 3){//已发货
        [self.followStauteBtn setTitle:@"状态跟踪" forState:UIControlStateNormal];
        self.followStauteBtn.userInteractionEnabled = YES;
        self.followStauteBtn.hidden = NO;
    }else if(order.status == 4){//已关闭
        self.followStauteBtn.hidden = YES;
    }else if (order.status == 5){
        [self.followStauteBtn setTitle:@"退款中" forState:UIControlStateNormal];
        self.followStauteBtn.userInteractionEnabled = NO;
        self.followStauteBtn.hidden = NO;
    }else if (order.status == 6){
        [self.followStauteBtn setTitle:@"已退款" forState:UIControlStateNormal];
        self.followStauteBtn.userInteractionEnabled = NO;
        self.followStauteBtn.hidden = NO;
    }
    
    
    self.productNumLabel.text = [NSString stringWithFormat:@"%ld",order.sumAmount];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf",order.sumPrice];
    self.CommissionLabel.text = [NSString stringWithFormat:@"￥%.2lf",order.sumCommission];
    self.postageLabel.text = [NSString stringWithFormat:@"运费(￥%.2lf)",order.shippingFee];
    if (order.buyerName) {
        self.reciverNameLabel.text = [NSString stringWithFormat:@"收货人:%@",order.buyerName];
    }else{
        self.reciverNameLabel.text = @"收货人";
    }
    
    self.orderString = order.sn;
}
@end
