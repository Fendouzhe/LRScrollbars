//
//  SMNewScheduleViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSchedule+CoreDataProperties.h"



@interface SMNewScheduleViewController : UIViewController

//是否为修改，修改需要调用更新Api
@property(nonatomic,assign)BOOL isModify;


@property(nonatomic,strong)LocalSchedule * localSchedule;


//修改时  传递的模型
@property(nonatomic,strong)Schedule * schedule;

//参与人员的数组   
@property(nonatomic,copy)NSMutableArray * participantArray;

//是否为团队任务
@property(nonatomic,assign)BOOL isTeamSchedule;



@end
