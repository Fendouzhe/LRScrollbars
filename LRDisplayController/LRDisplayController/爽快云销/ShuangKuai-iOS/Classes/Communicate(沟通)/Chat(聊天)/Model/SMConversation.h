//
//  SMConversation.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMConversation : NSObject

@property (nonatomic ,copy)NSString *iconStr;

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *lastMessage;

@property (nonatomic ,copy)NSString *time;

@property (nonatomic ,copy)NSString *userID;

@property (nonatomic,copy)NSString * clientId;

@property (nonatomic,copy)NSString * conversationId;

@property (nonatomic ,strong)User *user;
/**
 *  存时间戳
 */
@property (nonatomic ,assign)double unix;

@property (nonatomic,copy)NSString * unread;

@property (nonatomic,assign)BOOL isOther;

//产品id
@property(nonatomic,copy)NSString * pid;
@end
