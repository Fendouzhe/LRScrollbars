//
//  SMGroupChatHistoryViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class SMGroupChatDetailData;
@interface SMGroupChatHistoryViewController : RCConversationViewController
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@end
