//
//  SMFatherTask.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFatherTask : NSObject
@property (nonatomic ,copy)NSString *id;/**< <#注释#> */

@property (nonatomic ,copy)NSNumber *lastUpdate;/**< <#注释#> */

@property (nonatomic ,copy)NSString *uName;/**< <#注释#> */

@property (nonatomic ,copy)NSString *uPortrait;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *complateStatus;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *users;/**< <#注释#> */

@property (nonatomic ,strong)NSNumber *createAt;/**< <#注释#> */

@property (nonatomic ,copy)NSString *title;/**< <#注释#> */

@property (nonatomic ,copy)NSString *userId;/**< <#注释#> */


@property (nonatomic ,strong)NSArray *receiveStatus;/**< 接受状态 */

@property (nonatomic ,copy)NSString *remark;/**< 任务详情 */


@property (nonatomic ,strong)NSNumber *schTime;/**< <#注释#> */

@property (nonatomic ,assign)NSInteger status; /**< <#注释#> */

@property (nonatomic ,assign)NSInteger sonTaskNumber; /**< 子任务数 */

@end
