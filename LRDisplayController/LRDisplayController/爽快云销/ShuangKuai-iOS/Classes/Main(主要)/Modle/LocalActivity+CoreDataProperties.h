//
//  LocalActivity+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalActivity.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalActivity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyId;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSNumber *endTime;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *imagePaths;
@property (nullable, nonatomic, retain) NSNumber *lastUpdate;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *peoples;
@property (nullable, nonatomic, retain) NSNumber *startTime;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *isPlace;

@end

NS_ASSUME_NONNULL_END
