//
//  OrderProduct.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProduct : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double finalPrice;

@property (nonatomic, copy) NSString *detailId;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, copy) NSNumber *shippingFee;

@property (nonatomic, assign) NSInteger amount;
//对应买了的商品的规格
@property (nonatomic, copy) NSString *sku;
@end
