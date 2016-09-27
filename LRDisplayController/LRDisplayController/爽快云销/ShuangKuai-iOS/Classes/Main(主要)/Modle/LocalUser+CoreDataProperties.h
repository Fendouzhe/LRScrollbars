//
//  LocalUser+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *follows;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSString *intro;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *place;
@property (nullable, nonatomic, retain) NSString *portrait;
@property (nullable, nonatomic, retain) NSString *rtckey;
@property (nullable, nonatomic, retain) NSString *sumMoney;
@property (nullable, nonatomic, retain) NSString *telephone;
@property (nullable, nonatomic, retain) NSNumber *tweets;
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *companyId;

@end

NS_ASSUME_NONNULL_END
