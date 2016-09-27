//
//  TaskListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskListCellDelegate <NSObject>

@optional
-(void)clickNameWithUserID:(NSString *)userID;
@end

@class TaskListViewModel;
@interface TaskListCell : UITableViewCell
@property (nonatomic,strong) TaskListViewModel *cellData;/**< 模型    */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,weak) id<TaskListCellDelegate> delegate;/**< 代理 */
@end
