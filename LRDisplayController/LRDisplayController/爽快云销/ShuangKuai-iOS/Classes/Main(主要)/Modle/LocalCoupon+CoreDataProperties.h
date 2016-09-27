//
//  LocalCoupon+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalCoupon.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalCoupon (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *companyId;
@property (nullable, nonatomic, retain) NSString *companyImage;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSNumber *depositRate;
@property (nullable, nonatomic, retain) NSString *descr;
@property (nullable, nonatomic, retain) NSNumber *endTime;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *startTime;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
