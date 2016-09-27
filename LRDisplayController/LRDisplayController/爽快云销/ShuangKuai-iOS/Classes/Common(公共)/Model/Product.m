//
//  Product.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "Product.h"

@interface Product()

@end


@implementation Product


-(NSString *)description
{
    return [NSString stringWithFormat:@"sku = %@ ,skuSelected = %@ , name = %@",_sku,_skuSelected,_name];
}

+ (instancetype)modelWith:(NSString *)imagePath :(NSString *)productName :(NSNumber *)currenPricce :(NSNumber *)originalPrice :(NSNumber *)commision{
    
    Product *p = [[Product alloc] init];
    p.imagePath = imagePath;
    p.finalPrice = currenPricce;
    p.price = originalPrice;
    p.name = productName;
    p.commission = commision;
    return p;
}

//+ (instancetype)modelWithImagePath:(NSString *)imagePath{
//    Product *p = [[Product alloc] init];
//    p.imagePath = imagePath;
//    return p;
//}

+ (instancetype)modelWithAdImage:(NSString *)adImage{
    Product *p = [[Product alloc] init];
    p.adImage = adImage;
    return p;
}

@end
