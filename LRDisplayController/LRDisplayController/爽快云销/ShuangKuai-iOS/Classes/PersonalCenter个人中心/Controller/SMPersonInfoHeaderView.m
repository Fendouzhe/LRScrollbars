//
//  SMPersonInfoHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoHeaderView.h"

@implementation SMPersonInfoHeaderView

+(instancetype)sharedPersonInfoHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconWidthLayoutConstrait.constant = 68 * KMatch;
    self.iconHeightLayoutConstrait.constant = 68 * KMatch;
    self.iconButton.layer.cornerRadius = 68 * KMatch * 0.5;
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.borderWidth = 2.2;
    self.iconButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nickLabel.font = [UIFont systemFontOfSize:18*KMatch];
    self.instrolLabel.font = [UIFont systemFontOfSize:15*KMatch];
    //添加长按手势
    self.bjImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setBjImageViewLongPress:)];
    [self.bjImageView addGestureRecognizer:press];
}
//返回按钮点击
- (IBAction)backButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(personInfoHeaderViewBackBtnClick)]) {
        [self.delegate personInfoHeaderViewBackBtnClick];
    }
}
//编辑按钮点击
- (IBAction)editBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(personInfoHeaderViewEditBtnClick)]) {
        [self.delegate personInfoHeaderViewEditBtnClick];
    }
}
//设置按钮点击
- (IBAction)settingButonClick {
    if ([self.delegate respondsToSelector:@selector(personInfoHeaderViewSettingBtnClick)]) {
        [self.delegate personInfoHeaderViewSettingBtnClick];
    }
}
//头像点击
- (IBAction)iconButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(personInfoHeaderViewIconBtnClick:)]) {
        [self.delegate personInfoHeaderViewIconBtnClick:self];
    }
}
//背景长按手势
- (void)setBjImageViewLongPress:(UILongPressGestureRecognizer *)press{
    if ([self.delegate respondsToSelector:@selector(personInfoHeaderViewBjImageViewLongPress:)]) {
        [self.delegate personInfoHeaderViewBjImageViewLongPress:self];
    }
}

@end
