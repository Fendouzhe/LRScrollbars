//
//  SMEmotionTextView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionTextView.h"
#import "SMEmotion.h"
#import "NSString+Emoji.h"
#import "UITextView+Extention.h"

@implementation SMEmotionTextView

- (void)insertEmotion:(SMEmotion *)emotion{
    
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:emotion.png];
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, 300);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self insertAttributeText:imageStr];
        
        // 设置字体
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.attributedText;
        [text addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    }
}

@end
