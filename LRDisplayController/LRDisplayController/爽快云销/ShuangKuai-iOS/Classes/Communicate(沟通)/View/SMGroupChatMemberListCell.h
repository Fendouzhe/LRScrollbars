//
//  SMGroupChatMemberListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatroomMemberListData;
//@class SMGroupChatDetailData;

@interface SMGroupChatMemberListCell : UITableViewCell
@property (nonatomic,strong) ChatroomMemberListData *cellData;/**< cell model */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */

@property (nonatomic,copy)NSString *remark;

@end
