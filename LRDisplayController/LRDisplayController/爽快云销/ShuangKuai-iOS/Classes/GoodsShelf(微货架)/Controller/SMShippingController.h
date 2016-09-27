//
//  SMShippingController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMShippingController : UIViewController

/**
 *  选中商品的cart模型的数组
 */
@property(nonatomic,copy)NSMutableArray * cartArray;

@property (nonatomic ,assign) BOOL isDianxin;

@property (nonatomic ,copy)NSString *productID;

@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *cardNum;

@property (nonatomic ,copy)NSString *token1;
@property (nonatomic ,copy)NSString *token2;
@property (nonatomic ,copy)NSString *token3;

@property (nonatomic ,strong)ProductSpec *spec;

@property (nonatomic ,copy)NSString *specId;/**< <#注释#> */

@property (nonatomic ,copy)NSString *phoneNum;

@property (nonatomic ,copy)NSString *specPrice;/**< 选择规格之后的价格 */

@property (nonatomic ,copy)NSString *specName;/**< 规格详情 */

@property (nonatomic ,assign)BOOL isPushedByBuyNew; /**< 立即购买 push 过来的 */

@end
