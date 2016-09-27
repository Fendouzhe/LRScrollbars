//
//  Commission.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commission : NSObject
//关联的订单号
@property (nonatomic, retain) NSString *sn;
//订单生成的时间
@property (nonatomic, retain) NSString *createAt;
//处理时间
@property (nonatomic, retain) NSString *dealTime;
//佣金数
@property (nonatomic, assign) double commission;
//年份
@property (nonatomic, retain) NSString *year;
//月份
@property (nonatomic, retain) NSString *month;

@end
