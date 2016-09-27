//
//  Product.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesOrder : NSObject

@property (nonatomic, retain) NSString *id;

//订单的创建时间   (成交时间)
@property (nonatomic, assign) NSInteger createAt;

//订单号
@property (nonatomic, copy) NSString *sn;

//所有产品
@property (nonatomic, retain) NSArray *products;

//买家
@property (nonatomic, copy) NSString *buyerName;

//买家电话
@property (nonatomic, retain) NSString *buyerPhone;

//买家地址
@property (nonatomic, retain) NSString *buyerAddress;

//运费
@property (nonatomic, assign) double shippingFee;

//公司id
@property (nonatomic, retain) NSString *companyId;

//公司名称
@property (nonatomic, retain) NSString *companyName;

//总佣金
@property (nonatomic, assign) double sumCommission;

// 产品的总价格
@property (nonatomic, assign) double sumPrice;

//总数量
@property (nonatomic, assign) NSInteger sumAmount;

//订单状态
//public static final int STATUS_WAIT_PAY = 0; //待付款
//public static final int STATUS_WAIT_SEND = 1; //待发货
//public static final int STATUS_SENDED = 2; //已发货
//public static final int STATUS_FINISHED = 3; //已完成
//public static final int STATUS_CLOSED = 4; //已关闭
@property (nonatomic, assign) NSInteger status;

//成交时间
@property (nonatomic, assign) NSInteger dealTime;

//发货时间
@property (nonatomic, assign) NSInteger sendTime;

//付款时间
@property (nonatomic, assign) NSInteger payTime;

//支付渠道
@property (nonatomic, retain) NSString *channel;
//交易号
@property (nonatomic, retain) NSString *transactionNo;

//实付金额
@property (nonatomic, assign) double realPayMoney;
//   总价格  产品价格和邮费加在一起的总价格
@property (nonatomic ,assign) double payMoney;
/**
 *  运单号
 */
@property (nonatomic ,copy)NSString *shippingCode;
/**
 *  物流公司
 */
@property (nonatomic ,copy)NSString *comCode;
//类型 2代表活动邀请
@property (nonatomic, assign) NSInteger type;

@end
