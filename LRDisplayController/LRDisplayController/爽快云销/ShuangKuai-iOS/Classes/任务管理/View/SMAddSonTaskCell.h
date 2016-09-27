//
//  SMAddSonTaskCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAddSonTaskCellDelegate <NSObject>

- (void)addSonTaskAction;

@end

@interface SMAddSonTaskCell : UITableViewCell

@property (nonatomic ,weak)id<SMAddSonTaskCellDelegate> delegate;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrSonLists;/**< 子任务列表数据，SMSonTaskList  */

@property (nonatomic ,assign)NSInteger fatherStatus; /**< 父任务的状态，用来判断子任务是否可被编辑或者删除 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
