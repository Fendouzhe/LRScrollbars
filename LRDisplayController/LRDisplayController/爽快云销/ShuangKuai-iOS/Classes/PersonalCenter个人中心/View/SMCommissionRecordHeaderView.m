//
//  SMCommissionRecordHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommissionRecordHeaderView.h"

@interface SMCommissionRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *monthlyBillBtn;


@end

@implementation SMCommissionRecordHeaderView

+ (instancetype)commissionRecordHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCommissionRecordHeaderView" owner:nil options:nil] lastObject];
}

- (IBAction)monthlyBtnDidClick:(UIButton *)sender {
    SMLog(@"点击了 月账单 按钮");
    
    if ([self.delegate respondsToSelector:@selector(monthlyBillBtnDidClick:andMonth:)]) {
        NSString *year = [[self.monthLabel.text componentsSeparatedByString:@"-"] firstObject];
        NSString *month = [[self.monthLabel.text componentsSeparatedByString:@"-"] lastObject];
        [self.delegate monthlyBillBtnDidClick:year andMonth:month];
    }
}

- (void)awakeFromNib{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *attibuteStr = [[NSAttributedString alloc] initWithString:@"月账单" attributes:dict];
    [self.monthlyBillBtn setAttributedTitle:attibuteStr forState:UIControlStateNormal];
}



@end
