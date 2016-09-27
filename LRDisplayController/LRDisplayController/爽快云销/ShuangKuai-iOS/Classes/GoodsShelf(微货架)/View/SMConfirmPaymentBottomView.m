//
//  SMConfirmPaymentBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConfirmPaymentBottomView.h"

@interface SMConfirmPaymentBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SMConfirmPaymentBottomView

+ (instancetype)confirmPaymentBottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMConfirmPaymentBottomView" owner:nil options:nil] lastObject];
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    //结算
    
    if ([self.delegate respondsToSelector:@selector(ConfirmPaymentBottomViewRetainClick:)]) {
        [self.delegate ConfirmPaymentBottomViewRetainClick:sender];
    }
    
}

- (void)awakeFromNib{
    self.priceLabel.textColor = KRedColor;
    self.sureBtn.backgroundColor = KRedColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoney:) name:@"RetainMoney" object:nil];
}

-(void)refreshMoney:(NSNotification *)not{
    NSString * str =  not.userInfo[@"sumMoney"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf",[str doubleValue]];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString * str =  dataDic[@"sumMoney"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf",[str doubleValue]];
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    for (Cart * cart in dataArray) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf",[self.priceLabel.text doubleValue]+[cart.productFinalPrice doubleValue]];
    }
}
@end
