//
//  SMGroupChatViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class SMGroupChatListData,SMGroupChatDetailData;
@interface SMGroupChatViewController : RCConversationViewController
@property (nonatomic,strong) SMGroupChatListData *roomData;/**< 房间属性 */
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */

@property(nonatomic,copy) NSString *groupId;

@property (nonatomic,assign)BOOL isSearchVc;

@end
