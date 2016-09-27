//
//  SMParticipantController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMParticipantControllerDelegate <NSObject>

- (void)haveSelectedPerson:(NSArray *)array;

@end

@interface SMParticipantController : UIViewController

@property (nonatomic ,strong)NSArray *arrHaveChoosed;/**<  从子任务界面push 过来时 传进来的已选人 */

@property (nonatomic ,strong)NSArray *arrHaveChoosedPushedByFather;/**< 从父任务界面push 过来时 传进来的已选人 */

@property (nonatomic ,weak)id<SMParticipantControllerDelegate> delegate;/**< <#注释#> */

@end
