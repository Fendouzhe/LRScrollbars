//
//  chatroomMemberListData.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "ChatroomMemberListData.h"

@implementation ChatroomMemberListData
-(void)setUser:(User *)user{
    _user = user;
    _joinAt = nil;
    _portrait = user.portrait;
    _remark = nil;
    _id = nil;
    _roomId = nil;
    _userId = user.userid;
    _messageStatus = nil;
    _name = user.name;
}
@end
