//
//  TaskCommentCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class TaskCommentMessageViewModel;
@interface TaskCommentCell : SWTableViewCell
@property (nonatomic,strong) TaskCommentMessageViewModel *cellData;/**<  */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
