//
//  TaskOptimizationListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskListModel;
@interface TaskOptimizationListCell : UITableViewCell
@property (nonatomic,strong) TaskListModel *cellData;/**< 数据模型 */
@end
