//
//  Customer.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic, retain) NSString *id;

@property (nonatomic, copy) NSString *createAt;

@property (nonatomic, copy) NSString *lastUpdate;


//简称 （公司名／标题）
@property (nonatomic, copy) NSString *name;
//全称
@property (nonatomic, retain) NSString *fullname;
//电话
@property (nonatomic, copy) NSString *phone;
//地址
@property (nonatomic, copy) NSString *address;
//网址
@property (nonatomic, copy) NSString *website;
//客户编号
@property (nonatomic, copy) NSString *cno;
//介绍
@property (nonatomic, copy) NSString *intro;
//等级
@property (nonatomic, assign) NSInteger grade;
//客户状态
@property (nonatomic, assign) NSInteger status;
//email
@property (nonatomic, retain) NSString *email;
//意向商品
@property (nonatomic, copy) NSString *purpose;
//购买等级(意向等级)
@property (nonatomic, assign) NSInteger buyRating;
//标签
@property (nonatomic, copy) NSString *target;
//客户等级
@property (nonatomic, assign) NSInteger level;

@property (nonatomic ,assign)NSInteger sumOrder; /**< 订单总数 */

@property (nonatomic ,assign)BOOL isSelected; /**< 判断是否要打勾 */


@end
