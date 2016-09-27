//
//  SMNewProduct.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNewProduct : NSObject
//商品在外面的id
@property (nonatomic ,copy)NSString *itemId;
//商品 加入到柜台中去之后的id  （在删除柜台中商品时需要传的id）
@property (nonatomic ,copy)NSString *id;

@property (nonatomic ,copy)NSString *itemName;

@property (nonatomic ,strong) NSNumber *price;

@property (nonatomic ,copy)NSString *imagePath;

@property (nonatomic ,strong) NSNumber *createAt;

@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,strong) NSNumber *finalPrice;

@property (nonatomic ,copy)NSString *adImage;

//判断是否需要勾选 勾勾
@property (nonatomic ,assign)BOOL gouSelected;
//判断是否需要隐藏 勾勾按钮
@property (nonatomic ,assign)BOOL rightItemSelected;

@end
