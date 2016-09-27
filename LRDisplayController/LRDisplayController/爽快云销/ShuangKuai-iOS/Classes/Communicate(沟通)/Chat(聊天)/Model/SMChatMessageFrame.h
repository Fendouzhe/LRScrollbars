//
//  SMChatMessageFrame.h
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  按钮字体
 */
#define SMTextBtnFont [UIFont systemFontOfSize:15]
/**
 *  按钮内容的内边距
 */
#define SMTextBtnContentInset 20

@class SMChatMessage;
@interface SMChatMessageFrame : NSObject
/**
 *  会话对方的唯一标识  id
 */
@property(nonatomic,copy)NSString * targetRtcKey;

/**
 *  头像的frame
 */
@property(nonatomic,assign)CGRect iconF;

/**
 *  按钮的frame
 */
@property(nonatomic,assign)CGRect textBtnF;

/**
 *  时间的frame
 */
@property(nonatomic,assign)CGRect timeF;
/**
 *  行高
 */
@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,strong) SMChatMessage *messgae;

+(instancetype)messageFrameWithMeassge:(SMChatMessage *)message;

+(NSMutableArray *)messageFrames;

@end
