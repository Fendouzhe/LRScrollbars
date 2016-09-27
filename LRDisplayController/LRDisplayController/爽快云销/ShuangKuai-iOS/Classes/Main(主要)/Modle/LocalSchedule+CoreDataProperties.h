//
//  LocalSchedule+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalSchedule.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalSchedule (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *isProgress;
@property (nullable, nonatomic, retain) NSNumber *lastUpdate;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSString *remindTime;
@property (nullable, nonatomic, retain) NSNumber *schTime;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
