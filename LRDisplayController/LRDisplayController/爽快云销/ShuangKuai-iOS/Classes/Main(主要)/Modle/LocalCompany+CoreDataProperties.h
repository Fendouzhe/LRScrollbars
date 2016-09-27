//
//  LocalCompany+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalCompany.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalCompany (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSString *descr;
@property (nullable, nonatomic, retain) NSString *engName;
@property (nullable, nonatomic, retain) NSNumber *followers;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *isFollower;
@property (nullable, nonatomic, retain) NSNumber *lastUpdate;
@property (nullable, nonatomic, retain) NSString *logoPath;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *scale;

@end

NS_ASSUME_NONNULL_END
