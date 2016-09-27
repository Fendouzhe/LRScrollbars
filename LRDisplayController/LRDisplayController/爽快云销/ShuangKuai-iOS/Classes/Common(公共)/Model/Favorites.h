//
//  Favorites.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class Favorites;
//这个model代表两个东西：微货架/微推广
@interface Favorites : NSObject

@property (nonatomic ,assign)BOOL gouIsSelected;

@property (nonatomic ,assign)BOOL isMoveRight;

@property(nonatomic,assign)BOOL isCanClick;
/**
 *  0 产品   1 活动   2  优惠券
 */
@property(nonatomic,assign)NSInteger goodsType;

@property (nonatomic, copy) NSString *id;
/**
 *  微货架名字
 */
@property (nonatomic, retain) NSString *name;
/**
 *  可以不管 type = 1使用 0 未使用
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger createAt;
//???????????????
//当前我收藏的产品总数量
@property (nonatomic, retain) NSNumber *products;
//当前我收藏的活动总数量
@property (nonatomic, assign) NSInteger activitys;
//优惠券总数量
@property (nonatomic, assign) NSInteger coupons;
//是否需要加一个 正在使用的属性。  BOOL  isUsing?
//还有  兰兰说每个用户默认就有一个微货架

@end
