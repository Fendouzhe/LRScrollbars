//
//  SMComposeToolbar.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMComposeToolbar.h"

@interface SMComposeToolbar()
/**
 *  表情按钮
 */
@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation SMComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:SMComposeToolbarButtonTypeCamera];
        
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:SMComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:SMComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:SMComposeToolbarButtonTypeTrend];
        
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:SMComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton = showKeyboardButton;
    
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    //显示键盘图标
    if(showKeyboardButton){
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(SMComposeToolbarButtonType)type{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i < count; i++) {
        
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)btnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        
        [self.delegate composeToolbar:self didClickButton:btn.tag];
    }
}


@end
