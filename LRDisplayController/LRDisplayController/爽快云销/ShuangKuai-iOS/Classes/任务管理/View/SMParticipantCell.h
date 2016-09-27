//
//  SMParticipantCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSonTask.h"
#import "SMSonTaskList.h"
@class SMParticipant;
@interface SMParticipantCell : UITableViewCell

@property (nonatomic ,strong)UILabel *rightLabel;/**< 请选择任务参与人label */

@property (nonatomic ,strong)NSArray *arrIconStrs;/**< 装着SMFriend模型  SMFriend 内含有User模型 */

//@property (nonatomic ,strong)SMParticipant *participant;/**< 参与人 */

@property (nonatomic ,strong)NSMutableArray *arrParticipant;/**< <#注释#> */

//@property (nonatomic ,strong)SMSonTask *sonTask;/**< 子任务模型 */

@property (nonatomic ,strong)SMSonTaskList *list;/**< 子任务模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)haveNoParticipant;
@end
