//
//  LocalCustomer+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalCustomer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalCustomer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *cno;
@property (nullable, nonatomic, retain) NSString *createAt;
@property (nullable, nonatomic, retain) NSString *fullname;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *intro;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *level;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *website;
@property (nullable, nonatomic, retain) NSString *startTime;

@end

NS_ASSUME_NONNULL_END
