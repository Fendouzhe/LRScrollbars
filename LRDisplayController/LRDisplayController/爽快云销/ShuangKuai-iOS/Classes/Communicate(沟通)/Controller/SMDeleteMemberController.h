//
//  SMDeleteMemberController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMGroupChatDetailData.h"

@interface SMDeleteMemberController : UITableViewController

@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */

@property (nonatomic,strong) NSArray *chatroomMemberList;/**< 群聊人信息,ChatroomMemberListData */

@end
