//
//  StorageProduct.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageProduct : NSObject

@property (nonatomic, retain) NSString *id;

@property (nonatomic, retain) NSString *productId;
/**
 *  商品名字
 */
@property (nonatomic, retain) NSString *productName;

@property (nonatomic, assign) NSInteger createAt;

/**
 *  图片
 */
@property (nonatomic, retain) NSString *imagePath;
/**
 *  原价
 */
@property (nonatomic, retain) NSNumber *price;
/**
 *  现在价格
 */
@property (nonatomic, retain) NSNumber *finalPrice;

@end
