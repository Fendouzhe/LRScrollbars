//
//  SMEmotionButton.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionButton.h"
#import "SMEmotion.h"
#import "NSString+Emoji.h"
@implementation SMEmotionButton

/**
 *  当控件不是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
}

- (void)setEmotion:(SMEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) { // 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    
}


@end
