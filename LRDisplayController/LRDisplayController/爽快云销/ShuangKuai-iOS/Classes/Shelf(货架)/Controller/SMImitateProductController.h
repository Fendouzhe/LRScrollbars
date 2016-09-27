//
//  SMImitateProductController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMImitateProductController : UIViewController

@property (nonatomic ,strong)NSMutableArray *arrProductIDs;

@property (nonatomic ,strong)NSMutableArray *arrActionIDs;

@property (nonatomic ,strong)NSMutableArray *arrDiscountIDs;

/**
 *  当前选中的货架id
 */
@property (nonatomic ,copy)NSString *favID;

/**
 *  从活动按钮 点击push过来的
 */
@property (nonatomic ,assign)BOOL pushedByAction;
/**
 *  从优惠券按钮 点击push过来的
 */
@property (nonatomic ,assign)BOOL pushedByDiscount;

@end
