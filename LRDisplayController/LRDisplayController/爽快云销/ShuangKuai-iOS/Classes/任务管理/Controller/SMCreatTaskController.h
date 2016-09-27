//
//  SMCreatTaskController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCreatTaskControllerDelegate <NSObject>

@optional

- (void)editTaskSuccess;

@end

@interface SMCreatTaskController : UIViewController

@property (nonatomic,weak) id<SMCreatTaskControllerDelegate> delegate;/**< <#属性#> */

@property (nonatomic ,copy)NSString *fatherId;/**< 父任务id */

@property (nonatomic ,assign)BOOL isBeingUpdating; /**< 处于正在修改的状态,当处于被修改状态时，点保存做的事情时保存任务。 当不处于被修改状态时（新建状态），点保存，做的事情时新建任务 */

@end
