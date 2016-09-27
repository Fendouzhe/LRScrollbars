//
//  SMDataStation.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDataStation : NSObject

@property (nonatomic ,strong)NSNumber *id;/**< id */

@property (nonatomic ,copy)NSString *name;/**< 比如今日收入,标题 */

@property (nonatomic ,strong)NSNumber *status;/**< 打开的还是关闭的,状态 */

@property (nonatomic ,strong)NSNumber *value;/**< 暂时没用 */

@property (nonatomic ,assign)NSInteger type; /**< 唯一 */

@end
