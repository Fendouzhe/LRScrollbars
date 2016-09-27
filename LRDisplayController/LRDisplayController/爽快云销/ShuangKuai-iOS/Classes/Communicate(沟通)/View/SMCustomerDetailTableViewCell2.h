//
//  SMCustomerDetailTableViewCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalWorkLog+CoreDataProperties.h"
#import "LocalScheduleCompose+CoreDataProperties.h"

@interface SMCustomerDetailTableViewCell2 : UITableViewCell

/**
 *  发表的内容(评论)
 */
@property (nonatomic ,copy)NSString *comment;
@property (nonatomic ,strong)UILabel *commentLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)LocalWorkLog * localworklog;

@property(nonatomic,strong)LocalScheduleCompose * localScheduleCompose;
//
@property(nonatomic,strong)ScheduleDetail * scheduleDetail;

@property (nonatomic ,strong)WorkLog *log;

@end
