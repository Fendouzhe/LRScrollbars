//
//  SMSeckill.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSeckill : NSObject

@property (nonatomic ,strong)NSNumber *salesVolume;/**< 总销量 */

@property (nonatomic ,copy)NSString *seckillName;/**< 秒杀名字 */

@property (nonatomic ,strong)NSNumber *productAmount;/**< //秒杀商品数量 */

@property (nonatomic ,copy)NSString *id;/**< ID */

@property (nonatomic ,assign)NSInteger status; /**< 活动状态 （-1删除  0未开始; 1进行中; 2已结束） */

@property (nonatomic ,copy)NSString *descr;/**< 秒杀活动描叙 */

@property (nonatomic ,copy)NSString *imagePath;/**< 秒杀活动图片 */

@property (nonatomic ,assign)NSInteger createAt; /**< 创建时间   开始时间 */

@property (nonatomic ,assign)NSInteger lastUpdate; /**< 最近更改时间 */

@property (nonatomic ,copy)NSString *companyId;/**< 公司id */

@end
