//
//  SMEmotionKeyboard.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionKeyboard.h"
#import "SMEmotionTextView.h"
#import "SMComposeToolbar.h"
#import "SMComposePhotosView.h"

@interface SMEmotionKeyboard ()

//输入发表文字的控件
@property (nonatomic ,weak)SMEmotionTextView *textView;

//工具条
@property (nonatomic ,weak)SMComposeToolbar *toolbar;

//相册x
@property (nonatomic ,weak)SMComposePhotosView *photosView;

@property (nonatomic ,strong)SMEmotionKeyboard *emotionKeyboard;

@property (nonatomic ,assign)BOOL switchingKeybaord;

@end

@implementation SMEmotionKeyboard



@end
