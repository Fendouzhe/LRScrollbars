//
//  LocalSalesOrder+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalSalesOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalSalesOrder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *buyerAddress;
@property (nullable, nonatomic, retain) NSString *buyerName;
@property (nullable, nonatomic, retain) NSString *buyerPhone;
@property (nullable, nonatomic, retain) NSString *companyId;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) NSNumber *dealTime;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *payTime;
@property (nullable, nonatomic, retain) id products;
@property (nullable, nonatomic, retain) NSNumber *realPayMoney;
@property (nullable, nonatomic, retain) NSNumber *sendTime;
@property (nullable, nonatomic, retain) NSNumber *shippingFee;
@property (nullable, nonatomic, retain) NSString *sn;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *sumAmount;
@property (nullable, nonatomic, retain) NSNumber *sumCommission;
@property (nullable, nonatomic, retain) NSNumber *sumPrice;

@end

NS_ASSUME_NONNULL_END
