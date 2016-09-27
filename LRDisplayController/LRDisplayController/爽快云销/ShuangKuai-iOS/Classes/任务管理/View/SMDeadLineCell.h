//
//  SMDeadLineCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSonTaskList.h"
#import "SMSonTask.h"
@class SMFatherTask;

@interface SMDeadLineCell : UITableViewCell

@property (nonatomic ,strong)UILabel *rightLabel;/**< 请选择任务截止时间label */

@property (nonatomic ,strong)SMFatherTask *fatherTask;/**< 父任务模型 */

@property (nonatomic ,strong)SMSonTaskList *list;/**< 子任务模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
