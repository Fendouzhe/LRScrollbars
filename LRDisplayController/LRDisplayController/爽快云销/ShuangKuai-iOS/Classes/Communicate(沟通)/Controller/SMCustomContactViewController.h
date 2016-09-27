//
//  SMCustomContactViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMChatMessageFrame.h"
#import <AVIMConversation.h>
@interface SMCustomContactViewController : UIViewController


/**
 *  会话
 */
@property (nonatomic ,strong)AVIMConversation *conversation;

/**
 *  搜索客服的字段
 */
@property(nonatomic,copy)NSString * customerKeyWord;
/**
 *  是否为搜索
 */
@property(nonatomic,assign)BOOL isSearchCustomer;

/**
 *  当观察者不存在时，调用改方法来实现实时保存消息
 *
 *  @param user     发送消息的User
 *  @param messageF 消息体
 */
-(void)receiveConversationWithUser:(User *)user andChatMessgaeFrame:(SMChatMessageFrame *)messageF;

@end
