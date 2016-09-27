//
//  SMSonTaskList.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSonTask.h"

@interface SMSonTaskList : NSObject

@property (nonatomic ,strong)NSArray *childUser;/**< 装着子任务的参与者 SMParticipant */

@property (nonatomic ,strong)SMSonTask *childSchedule;/**< 子任务的详情 */

@end
