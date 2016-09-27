//
//  FavoritesDetail.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesDetail : NSObject

@property (nonatomic ,assign)BOOL isMoveRight;

@property (nonatomic ,assign)BOOL isAllSelected;

@property (nonatomic ,assign) BOOL isSelected;
//收藏的东东的id
@property (nonatomic, retain) NSString *id;
/**
 *  itemId实际对应的产品id/活动id/优惠券id
 */
@property (nonatomic, retain) NSString *itemId;
/**
 *  产品名/活动名/优惠券名
 */
@property (nonatomic, retain) NSString *itemName;
/**
 * type = 0 时item是产品,value1为原价,value2为现价 value3为佣金
 * type = 1 时item是活动,valu1/2/3可以不管，只管startTime活动时间和endTime结束时间
 * type = 2 时item是优惠券,value1为金额,value2为折扣率,value3不管
 */
/**
 *  原价
 */
@property (nonatomic, retain) NSNumber *value1;
/**
 *  现价
 */
@property (nonatomic, retain) NSNumber *value2;
/**
 *  佣金
 */
@property (nonatomic, retain) NSNumber *value3;

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) NSInteger type;
//优惠券时，这个是公司logo图片
@property (nonatomic, retain) NSString *imagePath;
//公司名
@property (nonatomic, retain) NSString *companyName;


@property (nonatomic, retain) NSString *descr;
//推广图
@property (nonatomic, retain) NSString *adImage;

+ (instancetype)modalWithAdimage:(NSString *)adImage itemName:(NSString *)itemName currentPrice:(NSNumber *)currentPrice;

@end
