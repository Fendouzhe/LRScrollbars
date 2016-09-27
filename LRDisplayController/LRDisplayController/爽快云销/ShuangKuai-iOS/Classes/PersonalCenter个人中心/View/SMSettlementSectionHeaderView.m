//
//  SMSettlementSectionHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSettlementSectionHeaderView.h"

@interface SMSettlementSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *commissionRecordBtn;


@end

@implementation SMSettlementSectionHeaderView

+ (instancetype)settlementSectionHeaderView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSettlementSectionHeaderView" owner:nil options:nil] lastObject];
}

- (IBAction)commissionRecordBtnClick:(UIButton *)sender {
    SMLog(@"点击了 佣金纪录 按钮");
    if ([self.delegate respondsToSelector:@selector(commissionBtnDidClick)]) {
        [self.delegate commissionBtnDidClick];
    }
    
}

- (void)awakeFromNib{
//    self.commissionRecordBtn.backgroundColor = KRedColor;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"佣金纪录" attributes:dict];
    [self.commissionRecordBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
}
@end
