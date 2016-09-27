//
//  SMDetailScheduleViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSchedule+CoreDataProperties.h"

@interface SMDetailScheduleViewController : UIViewController

@property(nonatomic,strong)LocalSchedule * localSchedule;

@property(nonatomic,copy)NSString * schId;

//yes 为团队任务 no 为个人任务
@property(nonatomic,assign)BOOL isTeamSchedule;

@end
