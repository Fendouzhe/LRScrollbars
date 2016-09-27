//
//  RecentSalesOrder.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSalesOrder : NSObject

@property(nonatomic,copy)NSString *sn;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,assign)CGFloat sumCommission;
@property(nonatomic,copy)NSString * createAt;
@property(nonatomic,assign)NSInteger sumPrice;

@end
