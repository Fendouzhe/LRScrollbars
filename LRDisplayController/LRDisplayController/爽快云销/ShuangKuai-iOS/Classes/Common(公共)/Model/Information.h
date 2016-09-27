//
//  Information.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/5/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject
//发送者ID
@property(nonatomic,copy)NSString * sender;
//消息ID
@property(nonatomic,retain)NSNumber *  messageId;
//接受者ID
@property(nonatomic,copy)NSString * receiver;
//内容
@property(nonatomic,copy)NSString * subject;
//时间
@property(nonatomic,assign)NSInteger sendTime;
//接收状态
@property(nonatomic,assign)NSInteger receiveStatus;
//消息类型
@property(nonatomic,assign)NSInteger type;
//好友信息
@property(nonatomic,copy)NSDictionary * body;

@end
