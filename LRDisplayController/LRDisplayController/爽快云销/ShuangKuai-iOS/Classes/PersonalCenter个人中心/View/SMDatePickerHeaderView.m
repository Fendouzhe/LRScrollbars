//
//  SMDatePickerHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDatePickerHeaderView.h"

@implementation SMDatePickerHeaderView

+ (instancetype)datePickerHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDatePickerHeaderView" owner:nil options:nil] lastObject];
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(topBtnDidClick:)]) {
        [self.delegate topBtnDidClick:sender];
    }
}

- (IBAction)completeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(topBtnDidClick:)]) {
        [self.delegate topBtnDidClick:sender];
    }
}

- (void)awakeFromNib{
    self.backgroundColor = SMColor(247, 254, 251);
}
@end
