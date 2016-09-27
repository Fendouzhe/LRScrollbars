//
//  SMEmotionTabBar.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionTabBar.h"
#import "SMEmotionTabBarButton.h"

@interface SMEmotionTabBar ()

/**
 *  正在被选中的按钮
 */
@property (nonatomic ,strong)SMEmotionTabBarButton *selectedBtn;

@end

@implementation SMEmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupBtn:NSLocalizedString(@"recent", nil) buttonType:SMEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:SMEmotionTabBarButtonTypeDefault];
        //        [self btnClick:[self setupBtn:@"默认" buttonType:HWEmotionTabBarButtonTypeDefault]];
        [self setupBtn:@"Emoji" buttonType:SMEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:SMEmotionTabBarButtonTypeLxh];
    }
    return self;
}

- (SMEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(SMEmotionTabBarButtonType)buttonType{
    
    SMEmotionTabBarButton *btn = [[SMEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    if (buttonType == SMEmotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    
    NSString *image = @"compose_emotion_table_mid_normal";;
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    //最左边和最右边显示的背景色是不一样的，所以要做个判断，分开设置
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //注意这里设置的是 Disabled
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        SMEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)btnClick:(SMEmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
}

- (void)setDelegate:(id<SMEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 选中“默认”按钮
    [self btnClick:(SMEmotionTabBarButton *)[self viewWithTag:SMEmotionTabBarButtonTypeDefault]];
}
@end
