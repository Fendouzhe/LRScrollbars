//
//  LocalBankCard+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalBankCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalBankCard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bankCard;
@property (nullable, nonatomic, retain) NSString *bankName;

@end

NS_ASSUME_NONNULL_END
