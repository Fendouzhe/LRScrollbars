//
//  LocalClassify+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalClassify.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalClassify (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *compangyId;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *parentId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *level;
@property (nullable, nonatomic, retain) NSString *sort;

@end

NS_ASSUME_NONNULL_END
