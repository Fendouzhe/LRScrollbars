//
//  Cart.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property (nonatomic,assign)BOOL isSelect;

@property (nonatomic, copy) NSString *id;

//数量
@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, assign) NSInteger createAt;

//产品的id
@property (nonatomic, copy) NSString *productId;

//产品的name
@property (nonatomic, copy) NSString *productName;

//产品的价格(原价)
@property (nonatomic, retain) NSNumber *productPrice;

//产品的价格(现价)
@property (nonatomic, retain) NSNumber *productFinalPrice;

//图片路径
@property (nonatomic, copy) NSString *imagePath;
//@property (nonatomic ,strong)NSArray *imagePath;/**< <#注释#> */

//公司id
@property (nonatomic, copy) NSString *companyId;

//公司name
@property (nonatomic, copy) NSString *companyName;

//运费
@property (nonatomic, retain) NSNumber *shippingFee;

@property (nonatomic ,copy)NSString *sku;/**< 已选中规格 */
//类型
@property (nonatomic ,copy)NSString *classModel;

@end
