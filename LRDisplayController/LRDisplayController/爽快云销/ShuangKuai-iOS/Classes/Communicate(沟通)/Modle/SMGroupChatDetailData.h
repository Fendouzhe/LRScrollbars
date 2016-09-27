//
//  SMGroupChatDetailData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMGroupChatListData.h"

@interface SMGroupChatDetailData : NSObject
@property (nonatomic,strong) NSArray *chatroomMemberList;/**< 群聊人信息,ChatroomMemberListData */
@property (nonatomic,strong) SMGroupChatListData *chatroom;/**< 房间信息 */
@end
