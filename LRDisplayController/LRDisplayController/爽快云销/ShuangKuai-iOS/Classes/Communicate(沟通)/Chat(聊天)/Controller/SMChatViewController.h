//
//  SMChatViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMConversation.h>
@class AVIMClient;
@interface SMChatViewController : UIViewController

/**
 *  聊天对象的 RtcKey
 */
@property (nonatomic ,strong)NSString *targetRtcKey;

@property (nonatomic ,strong)User *user;

/**
 *  发消息
 */
@property (nonatomic, strong) AVIMClient *client;

/**
 *  会话
 */
@property (nonatomic ,strong)AVIMConversation *conversation;

/**
 *  是否是客服
 */
@property (nonatomic, assign)BOOL isCustomer;

@property (nonatomic,copy)NSString * conversationId;
//产品id 
@property(nonatomic,copy)NSString * pid;
@end