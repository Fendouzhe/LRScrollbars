//
//  LocalFavoritesDetail+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalFavoritesDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalFavoritesDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isMoveRight;
@property (nullable, nonatomic, retain) NSNumber *isAllSelected;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *itemId;
@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSNumber *value1;
@property (nullable, nonatomic, retain) NSNumber *value2;
@property (nullable, nonatomic, retain) NSNumber *value3;
@property (nullable, nonatomic, retain) NSNumber *startTime;
@property (nullable, nonatomic, retain) NSNumber *endTime;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSString *descr;
@property (nullable, nonatomic, retain) NSString *favID;

@end

NS_ASSUME_NONNULL_END
