//
//  LocalAd+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalAd (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *adName;
@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSString *link;

@end

NS_ASSUME_NONNULL_END
