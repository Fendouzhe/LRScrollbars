//
//  SMscheduleDetailTableViewCell2.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSchedule.h"

typedef void(^editBlock)(void);

@interface SMscheduleDetailTableViewCell2 : UITableViewCell


@property(nonatomic,strong)LocalSchedule * localSchedule;

@property(nonatomic,strong)editBlock editblock;

@property(nonatomic,strong)Schedule * schedule;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@end
