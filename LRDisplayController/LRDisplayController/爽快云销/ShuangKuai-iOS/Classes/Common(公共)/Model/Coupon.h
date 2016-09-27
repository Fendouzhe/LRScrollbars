//
//  Coupon.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic, retain) NSString *id;
//优惠码（在产品库中的不会用到优惠码）
@property (nonatomic, retain) NSString *code;
//优惠券名
@property (nonatomic, retain) NSString *name;
//优惠券开始时间
@property (nonatomic, assign) NSInteger startTime;
//优惠券结束时间
@property (nonatomic, assign) NSInteger endTime;
//优惠券详情
@property (nonatomic, retain) NSString *descr;
//状态 0未使用  1已使用
@property (nonatomic, assign) NSInteger status;
//优惠券类型
@property (nonatomic, assign) NSInteger type;
//企业id
@property (nonatomic, copy) NSString *companyId;
//优惠券所属企业
@property (nonatomic, copy) NSString *companyName;
//所属企业的图片
@property (nonatomic, copy) NSString *companyImage;
//兑换券是没金额的 ，优惠券才有金额
@property (nonatomic, assign) double money;
//折扣率券
@property (nonatomic, assign) double depositRate;

@end
