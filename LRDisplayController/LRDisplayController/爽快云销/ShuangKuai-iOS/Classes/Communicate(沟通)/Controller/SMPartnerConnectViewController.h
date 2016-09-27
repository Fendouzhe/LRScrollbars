//
//  SMPartnerConnectViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMChatMessageFrame.h"
@interface SMPartnerConnectViewController : UIViewController

/**
 *  搜索伙伴的字段
 */
@property(nonatomic,copy)NSString * partnerKeyWord;
/**
 *  搜索联系人的字段
 */
@property (nonatomic,copy)NSString * keyWord;

/**
 *  是否为搜索联系人
 */
@property (nonatomic,assign)BOOL isSearchContact;
/**
 *  是否为搜索伙伴
 */
@property (nonatomic,assign)BOOL isSearchPartner;
/**
 *  是否为搜索陌生朋友
 */
@property (nonatomic,assign)BOOL isSearchFriend;

/**
 *  请求数据
 */
-(void)requestData;

/**
 *  当观察者不存在时，调用改方法来实现实时保存消息
 *
 *  @param user     发送消息的User
 *  @param messageF 消息体
 */
-(void)receiveConversationWithUser:(User *)user andChatMessgaeFrame:(SMChatMessageFrame *)messageF;


@end
