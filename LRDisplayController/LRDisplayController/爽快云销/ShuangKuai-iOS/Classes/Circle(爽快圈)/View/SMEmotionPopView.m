//
//  SMEmotionPopView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionPopView.h"
#import "SMEmotionButton.h"

@interface SMEmotionPopView ()

@property (weak, nonatomic) IBOutlet SMEmotionButton *emotionButton;

@end

@implementation SMEmotionPopView

+ (instancetype)popView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HWEmotionPopView" owner:nil options:nil] lastObject];
    
}

- (void)setEmotion:(SMEmotion *)emotion
{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}

@end
