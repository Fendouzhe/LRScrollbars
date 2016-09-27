//
//  LocalOrderProduct+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalOrderProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalOrderProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *detailId;
@property (nullable, nonatomic, retain) NSNumber *finalPrice;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *productId;
@property (nullable, nonatomic, retain) NSString *productName;

@end

NS_ASSUME_NONNULL_END
