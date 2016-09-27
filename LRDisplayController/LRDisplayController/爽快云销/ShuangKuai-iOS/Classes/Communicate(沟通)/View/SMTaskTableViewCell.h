//
//  SMTaskTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSchedule+CoreDataProperties.h"
@interface SMTaskTableViewCell : UITableViewCell

+ (instancetype)taskTableViewCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//-(void)refreshUI:(LocalSchedule *)schedule;

@property(nonatomic,strong)Schedule * schedule;

@end
