//
//  LocalFavorites+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalFavorites.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalFavorites (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *products;
@property (nullable, nonatomic, retain) NSNumber *activitys;
@property (nullable, nonatomic, retain) NSNumber *coupons;
@property (nullable, nonatomic, retain) NSNumber *isMoveRight;

@end

NS_ASSUME_NONNULL_END
