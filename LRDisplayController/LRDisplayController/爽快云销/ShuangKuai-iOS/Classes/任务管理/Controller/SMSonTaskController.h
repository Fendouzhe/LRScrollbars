//
//  SMSonTaskController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSonTask.h"
#import "SMSonTaskList.h"
@interface SMSonTaskController : UIViewController

@property (nonatomic ,copy)NSString *fatherId;/**< 父任务id */

//@property (nonatomic ,strong)SMSonTask *sonTask;/**< 子任务模型 */
@property (nonatomic ,strong)SMSonTaskList *list;/**< 子任务模型 */

@property (nonatomic ,assign)BOOL isBeingUpdating; /**< 处于正在修改的状态,当处于被修改状态时，点保存做的事情时保存子任务。 当不处于被修改状态时（新建状态），点保存，做的事情时新建子任务 */

@end
