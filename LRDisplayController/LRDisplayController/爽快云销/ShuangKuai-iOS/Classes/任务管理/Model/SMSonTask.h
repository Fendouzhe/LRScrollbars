//
//  SMSonTask.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSonTask : NSObject

@property (nonatomic ,copy)NSString *id;/**< <#注释#> */

@property (nonatomic ,strong)NSNumber *lastUpdate;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *complateStatus;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *users;/**< 参与者的id */
//@property (nonatomic ,strong)NSArray *users;/**< 注释 */

@property (nonatomic ,strong)NSNumber *createAt;/**< <#注释#> */

@property (nonatomic ,copy)NSString *title;/**< <#注释#> */

@property (nonatomic ,strong)NSNumber *rownum;/**< 第几个子任务 */

@property (nonatomic ,copy)NSString *userId;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *receiveStatus;/**< <#注释#> */

@property (nonatomic ,copy)NSString *remark;/**< <#注释#> */

@property (nonatomic ,strong)NSNumber *schTime;/**< <#注释#> */

@property (nonatomic ,copy)NSString *fatherId;/**< 父任务ID */

@property (nonatomic ,assign)NSInteger status; /**< 任务状态 *///0 未发布，1未完成，2已完成,且所有子任务默认都是未完成.


@end
