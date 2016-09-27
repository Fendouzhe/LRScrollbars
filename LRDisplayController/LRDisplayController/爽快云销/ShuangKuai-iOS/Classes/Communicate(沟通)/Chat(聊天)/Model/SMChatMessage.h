//
//  SMChatMessage.h
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HMMessageTypeMe, // 自己发的 0
    HMMessageTypeOther,// 别人发的 1
} HMMessageType;

@interface SMChatMessage : NSObject<NSCopying>
/**
 *  时间
 */
@property(nonatomic,copy)NSString *time;
/**
 *  聊天内容
 */
@property(nonatomic,copy)NSString *text;
/**
 *  消息类型
 */
@property(nonatomic,assign)HMMessageType type;

/**
 *  是否隐藏时间 YES:隐藏 NO:不隐藏
 */
@property(nonatomic,assign)BOOL hideTime;


@property(nonatomic,copy)NSString * OtherClientId;
/**
 *  会话Id  房间的id
 */
@property(nonatomic,copy)NSString * conversationId;

/**
 *  时间戳
 */
@property(nonatomic,assign)double unix;

//如果是客服  携带的产品id 
@property(nonatomic,copy)NSString * pid;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)messageWithDict:(NSDictionary *)dict;

@end
