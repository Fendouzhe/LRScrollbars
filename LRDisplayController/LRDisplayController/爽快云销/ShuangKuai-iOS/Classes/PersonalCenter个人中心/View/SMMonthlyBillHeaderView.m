//
//  SMMonthlyBillHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMonthlyBillHeaderView.h"

@interface SMMonthlyBillHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation SMMonthlyBillHeaderView

+ (instancetype)monthlyBillHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMMonthlyBillHeaderView" owner:nil options:nil] lastObject];
}


- (IBAction)monthBtnClick:(UIButton *)sender {
    SMLog(@"点击了 选择月份 按钮");
    if ([self.delegate respondsToSelector:@selector(monthChooseBtnDidClick)]) {
        [self.delegate monthChooseBtnDidClick];
    }
}

-(void)awakeFromNib{
    self.bottomView.backgroundColor = KControllerBackGroundColor;
}

@end
