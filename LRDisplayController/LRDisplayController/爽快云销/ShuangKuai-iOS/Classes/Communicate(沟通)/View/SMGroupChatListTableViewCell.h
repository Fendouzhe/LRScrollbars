//
//  SMGroupChatListTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class SMGroupChatListData,SWTableViewCell;
@interface SMGroupChatListTableViewCell : UITableViewCell
@property (nonatomic,strong) SMGroupChatListData *cellData;/**< 数据 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
