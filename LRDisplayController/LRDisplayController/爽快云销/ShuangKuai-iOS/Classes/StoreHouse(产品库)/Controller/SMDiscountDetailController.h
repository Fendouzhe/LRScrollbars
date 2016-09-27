//
//  SMDiscountDetailController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalCoupon+CoreDataProperties.h"

@protocol SMDiscountDetailControllerDelegate <NSObject>

- (void)addDiscountToShelf:(NSString *)discountID;

@end

@interface SMDiscountDetailController : UIViewController
/**
 *  从货架界面push过来的时候，优惠券就变成不可点状态
 */
@property (nonatomic ,assign)BOOL pushedByShelf;

@property(nonatomic,strong)Coupon* coupon;

@property(nonatomic,copy)NSMutableArray * arrDiscountIDs;

@property (nonatomic ,weak)id<SMDiscountDetailControllerDelegate> delegate;


/**
 *  判断是否是在柜台模板中进入的
 这边只允许下架
 */
@property(nonatomic,assign)BOOL isPushCounter;
/**
 *  只允许上架
 */
@property(nonatomic,assign)BOOL isup;
/**
 *  当前跳转的货架
 */
@property(nonatomic,strong)Favorites * favorites;

/**
 *  从微柜台进入的时候  显示出加入购物车
 */
@property(nonatomic,assign)BOOL isGoodsShelf;

@end
