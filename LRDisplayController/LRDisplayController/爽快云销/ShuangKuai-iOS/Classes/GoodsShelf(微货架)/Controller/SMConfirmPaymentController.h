//
//  SMConfirmPaymentController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModle.h"

@interface SMConfirmPaymentController : UIViewController

/**
 *  收货信息
 */
@property(nonatomic,strong)addressModle * address;
/**
 *  装cart的数组  商品
 */
@property (nonatomic,copy)NSMutableArray * cartArray;
//要购买的商品id数组
@property (nonatomic ,strong)NSMutableArray *arrProductIDs;

@property (nonatomic ,copy)NSString *specPrice;/**< 选择规格之后的价格 */

@property (nonatomic ,copy)NSString *specName;/**< 规格详情 */

@property (nonatomic ,assign)BOOL isPushedByBuyNew; /**< 通过点击 “立即购买” push 过来的 */


@end
