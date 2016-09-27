//
//  SMScheduleBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMScheduleBottomView.h"

@interface SMScheduleBottomView ()
/**
 *  已完成按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *alreadyDoneBtn;
/**
 *  未完成按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *notDoneBtn;
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end

@implementation SMScheduleBottomView

+ (instancetype)scheduleBottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMScheduleBottomView" owner:nil options:nil] lastObject];
}

- (IBAction)alreadyBtnClick:(UIButton *)sender {
    SMLog(@"点击了 已完成");
    if ([self.delegate respondsToSelector:@selector(scheduleBtnDidClick:)]) {
        [self.delegate scheduleBtnDidClick:sender];
    }
}

- (IBAction)notDoneBtnClick:(UIButton *)sender {
    SMLog(@"点击了 未完成");
    if ([self.delegate respondsToSelector:@selector(scheduleBtnDidClick:)]) {
        [self.delegate scheduleBtnDidClick:sender];
    }
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    SMLog(@"点击了 取消");
    if ([self.delegate respondsToSelector:@selector(scheduleBtnDidClick:)]) {
        [self.delegate scheduleBtnDidClick:sender];
    }
}


@end
