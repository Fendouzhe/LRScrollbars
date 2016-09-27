//
//  SMNewChatViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/5/31.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class User;
@interface SMNewChatViewController : RCConversationViewController
@property (nonatomic,strong) User *user;

@property (nonatomic,assign)BOOL isSearchVc;

@end
