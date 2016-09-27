//
//  SMProductDetailController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProductDetailController : UIViewController

@property (nonatomic ,strong)Product *product;

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
/**
 *  属于柜台部分
 */
@property (nonatomic ,assign) BOOL isBelongCounter;

/**
 *  itemId实际对应的产品id/活动id/优惠券id
 */
@property (nonatomic, retain) NSString *itemId;

@end
