//
//  ChildScheduleModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSonTask;
@interface ChildScheduleModel : NSObject
@property (nonatomic,strong) SMSonTask *childSchedule;/**< <#属性#> */
@property (nonatomic,strong) NSArray *childUser;/**< 用户数组,SMParticipant */
@end
