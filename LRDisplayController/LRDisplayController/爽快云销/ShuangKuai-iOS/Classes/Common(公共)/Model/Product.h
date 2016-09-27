//
//  Product.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *id;/**< 商品ID */

@property (nonatomic, assign) NSInteger createAt;
/**
 *  描述  用webView加载的
 */
@property (nonatomic, copy) NSString *descr;
/**
 *  商品名字
 */
@property (nonatomic, copy) NSString *name;
/**
 *  关注数
 */
@property (nonatomic, assign) NSInteger followers;

@property (nonatomic, assign) NSInteger lastUpdate;
/**
 *  图片
 */
@property (nonatomic, copy) NSString *imagePath;
/**
 *  原价
 */
@property (nonatomic, retain) NSNumber *price;
/**
 *  现在价格
 */
@property (nonatomic, strong) NSNumber *finalPrice;
/**
 *  公司名
 */
@property (nonatomic, retain) NSString *companyName;
/**
 *  佣金
 */
@property (nonatomic, retain) NSNumber *commission;

/**
 *  库存
 */
@property (nonatomic, assign) NSInteger stock;
/**
 *  销售量
 */
@property (nonatomic, assign) NSInteger sales;
/**
 *  商品SKU
 */
@property (nonatomic, copy) NSString *sku;
/**
 *  商品SKU Selected
 */
@property (nonatomic, copy) NSString *skuSelected;
//运费
@property (nonatomic, retain) NSNumber *shippingFee;

@property (nonatomic, copy)NSString * companyLogoPath;

/**
 *  推广图  长方形的大图
 */
@property (nonatomic, retain) NSString *adImage;

/**
 *  产品类型  如果返回的字符串是@“dianxin” 就证明这个商品是电信商品
 */
@property (nonatomic, retain) NSString *classModel;

/**
 * 视频地址
 */
@property (nonatomic, retain) NSString *videoPath;

@property (nonatomic ,assign)CGFloat webHeight; /**< <#注释#> */

@property (nonatomic,assign,getter=isSelect) BOOL select;/**< 选中状态 */

@property (nonatomic,assign) CGFloat rowHeight;

+ (instancetype)modelWith:(NSString *)imagePath :(NSString *)productName :(NSNumber *)currenPricce :(NSNumber *)originalPrice :(NSNumber *)commision;

//+ (instancetype)modelWithImagePath:(NSString *)imagePath;
+ (instancetype)modelWithAdImage:(NSString *)adImage;




@end
