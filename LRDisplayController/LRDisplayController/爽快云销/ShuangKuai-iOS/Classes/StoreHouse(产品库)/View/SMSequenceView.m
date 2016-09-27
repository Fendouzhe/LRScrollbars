//
//  SMSequenceView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSequenceView.h"

@interface SMSequenceView ()

@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation SMSequenceView

+ (instancetype)sequenceViewWithTopTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle{
    SMSequenceView *view = [[[NSBundle mainBundle] loadNibNamed:@"SMSequenceView" owner:nil options:nil] lastObject];
    [view.topBtn setTitle:topTitle forState:UIControlStateNormal];
    [view.bottomBtn setTitle:bottomTitle forState:UIControlStateNormal];
    return view;
}

- (IBAction)topBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(topBtnDidClick:viewTag:)]) {
        [self.delegate topBtnDidClick:sender viewTag:(int)self.tag];
    }
}

- (IBAction)bottomBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(bottomBtnDidClick:viewTag:)]) {
        [self.delegate bottomBtnDidClick:sender viewTag:(int)self.tag];
    }
}

@end
