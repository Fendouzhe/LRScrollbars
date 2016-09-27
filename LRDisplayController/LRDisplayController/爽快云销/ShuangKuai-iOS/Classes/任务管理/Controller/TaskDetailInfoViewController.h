//
//  TaskDetailInfoViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^refreshBlock)();
@interface TaskDetailInfoViewController : UIViewController
@property (nonatomic,copy) NSString *taskID;/**< 任务ID */

@property (nonatomic,strong) Schedule *schedule;/**< 任务 */

@property (nonatomic ,copy)refreshBlock block;/**< <#注释#> */
@end
