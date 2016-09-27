//
//  TaskListModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,TaskStatusType ) {
    TaskStatusTypeNOPublish,//没有发布
    TaskStatusTypeNOComplete,//未完成
    TaskStatusTypeComplete//已经完成
};

@interface TaskListModel : NSObject
@property (nonatomic,strong) Schedule *schedule;/**< 任务 */
@property (nonatomic,strong) NSArray *usersList;/**< 参与人 */
@end
