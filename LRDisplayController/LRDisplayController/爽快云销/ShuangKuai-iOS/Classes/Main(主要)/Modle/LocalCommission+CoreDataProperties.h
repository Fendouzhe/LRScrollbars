//
//  LocalCommission+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalCommission.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalCommission (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *commission;
@property (nullable, nonatomic, retain) NSString *createAt;
@property (nullable, nonatomic, retain) NSString *dealTime;
@property (nullable, nonatomic, retain) NSString *month;
@property (nullable, nonatomic, retain) NSString *sn;
@property (nullable, nonatomic, retain) NSString *year;

@end

NS_ASSUME_NONNULL_END
