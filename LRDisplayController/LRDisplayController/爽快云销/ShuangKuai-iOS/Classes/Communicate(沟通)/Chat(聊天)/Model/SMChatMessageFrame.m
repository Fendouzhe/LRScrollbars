//
//  SMChatMessageFrame.m
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "SMChatMessageFrame.h"
#import "SMChatMessage.h"
#import "NSString+Extension.h"
@implementation SMChatMessageFrame

- (void)setMessgae:(SMChatMessage *)messgae {
    _messgae = messgae;
    // 获得屏幕的宽度
    CGFloat screenW = KScreenWidth;
    // 设置左右间接
    CGFloat margin = 10;
    
    // 计算子控件的frame
    // 计算时间的frame
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = screenW;
    CGFloat timeH = 30;
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 计算头像的frame
    CGFloat iconW = 40;
    CGFloat iconH = iconW;
    CGFloat iconY = timeH;
    CGFloat iconX = margin;
    
    if (messgae.type == HMMessageTypeMe) { // 自己的头像
        // 头像x值 = 屏幕的宽度 - 头像的宽度 - 间距
        iconX = screenW - iconW - margin;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 设置按钮的frame
    CGFloat textBtnX = iconX + iconW + margin; // 其他人发的
    CGFloat textBtnY = iconY;
    // 获得聊天内容
    NSString *text = messgae.text;
    CGFloat maxWidth = 200;
    // 设置计算范围
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    // 计算聊天内容实际占据的区域
    //    CGSize textSize =  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:HMTextBtnFont} context:nil].size;
    
    CGSize textSize = [text textSizeWithFont:SMTextBtnFont maxSize:maxSize];
    
    CGFloat textBtnW = textSize.width + 2 * SMTextBtnContentInset;
    CGFloat textBtnH = textSize.height + 2 * SMTextBtnContentInset;
    if(messgae.type == HMMessageTypeMe) { // 自己发的
        //按钮x值 = 头像的x值  - 间距 - 按钮本身的宽度
        textBtnX = iconX - margin - textBtnW;
    }
    _textBtnF = CGRectMake(textBtnX, textBtnY, textBtnW, textBtnH);
    
    // 计算行高
    // 头像的最大y值
    CGFloat iconMaxY = iconY + iconH;
    // 按钮的最大y值
    CGFloat textBtnMaxY = textBtnY + textBtnH;
    
    _cellHeight = MAX(iconMaxY, textBtnMaxY) + margin ;
}

+(instancetype)messageFrameWithMeassge:(SMChatMessage *)message{
    SMChatMessageFrame *messageFrame = [[self alloc] init];
    messageFrame.messgae = message;
    return messageFrame;
}

+(NSMutableArray *)messageFrames{
    // 获得文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
    // 获得数据
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    // 创建模型数组
    NSMutableArray *messageFrames = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        // 将字典转换成message模型
        SMChatMessage *message = [SMChatMessage messageWithDict:dict];
        
        // 获得数组中最后一个frame模型
        SMChatMessageFrame *lastMessageFrame = [messageFrames lastObject];
        // 获得frame模型对应message模型
        SMChatMessage *lastMessage = lastMessageFrame.messgae;
        // 获得时间
        NSString *lastTime = lastMessage.time;
        // 如果当前message模型的时间等于上一个message模型的时间，则隐藏当前message模型的时间
        if ([lastTime isEqualToString:message.time]) {
            message.hideTime = YES; //隐藏
        }
        
        // 创建一个frame模型
        SMChatMessageFrame *messageFrame = [SMChatMessageFrame messageFrameWithMeassge:message];
        // 将frame模型添加到数组中
        [messageFrames addObject:messageFrame];
    }
    
    return messageFrames;
}
@end
