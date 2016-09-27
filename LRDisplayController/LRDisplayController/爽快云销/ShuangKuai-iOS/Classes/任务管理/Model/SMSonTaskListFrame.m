//
//  SMSonTaskListFrame.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSonTaskListFrame.h"
#import "SMSonTaskList.h"

@implementation SMSonTaskListFrame

- (void)setList:(SMSonTaskList *)list{
    _list = list;
    
    CGSize titleSize = [self sizeWithText:@"子任务" font:KDefaultFontSmall maxW:KScreenWidth - 20];
    self.titleF = CGRectMake(10, 5, titleSize.width, titleSize.height);
    
    
    CGSize remarkSize = [self sizeWithText:list.childSchedule.remark font:KDefaultFont maxW:KScreenWidth - 20];
    CGFloat remarkY = CGRectGetMaxY(self.titleF) + 5;
    self.contentF = CGRectMake(10, remarkY, remarkSize.width, remarkSize.height);
    
    
    CGFloat participantY = CGRectGetMaxY(self.contentF) + 5;
    CGFloat participantViewH = 35 *SMMatchHeight;
    self.participantViewF = CGRectMake(0, participantY, KScreenWidth - 20, participantViewH);
    
    
    CGSize particilabelSize = [self sizeWithText:@"参与人:" font:KDefaultFontSmall maxW:KScreenWidth - 20];
    CGFloat particilabelY = (participantViewH - particilabelSize.height) / 2.0;
    self.participantF = CGRectMake(10, particilabelY, particilabelSize.width, particilabelSize.height);
    
    
    CGFloat btnWH = 25 *SMMatchHeight;
    CGFloat btn0X = CGRectGetMaxX(self.participantF) + 5;
    CGFloat btnY = (35 *SMMatchHeight - 25 *SMMatchHeight) / 2.0;
    self.btn0F = CGRectMake(btn0X, btnY, btnWH, btnWH);
    
    CGFloat btn1X = CGRectGetMaxX(self.btn0F);
    self.btn1F = CGRectMake(btn1X, btnY, btnWH, btnWH);
    
    CGFloat btn2X = CGRectGetMaxX(self.btn1F);
    self.btn2F = CGRectMake(btn2X, btnY, btnWH, btnWH);
    
    CGFloat btn3X = CGRectGetMaxX(self.btn2F);
    self.btn3F = CGRectMake(btn3X, btnY, btnWH, btnWH);
    
    CGFloat btn4X = CGRectGetMaxX(self.btn3F);
    self.btn4F = CGRectMake(btn4X, btnY, btnWH, btnWH);
    
    CGFloat btn5X = CGRectGetMaxX(self.btn4F);
    self.btn5F = CGRectMake(btn5X, btnY, btnWH, btnWH);
    
    CGFloat statusX = CGRectGetMaxX(self.titleF) + 10;
    CGFloat statusY = CGRectGetMinY(self.titleF);
    CGFloat statusW = KScreenWidth - statusX - 10;
    CGSize statusSize = [self sizeWithText:@"未完成" font:KDefaultFontSmall];
    self.statusBtnF = CGRectMake(statusX, statusY, statusW, statusSize.height);
    
    
    CGFloat grayLineY = CGRectGetMaxY(self.participantViewF);
    self.grayLineF = CGRectMake(0, grayLineY, KScreenWidth, 1);
    
    self.cellHeight = CGRectGetMaxY(self.participantViewF) + 1;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //设置内容最宽 只能到maxW ，但是高度不限制。
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

// 这个是对于单行的字符串内容
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}


@end
