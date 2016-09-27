//
//  SMNewProductDetailController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewProductDetailController : UIViewController

@property (nonatomic ,copy)NSString *productId;/**< <#注释#> */

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,assign)NSInteger mode; /**< 模式  
                                              模式1=上下架模式（微商城进入）
                                              模式2=购买模式（微柜台进入）
                                              模式3=只读模式（购物车进入） */
@property (nonatomic ,copy)NSString *productName;

@end
