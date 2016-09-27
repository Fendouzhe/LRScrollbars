//
//  SMGroupbuyDetailList.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMGroupbuyDetailList : NSObject

/*
    lastUpdate = 1474340764;
	id = 0df14f6a40bd46daae64ea060191555a;
	startTime = 1474300800;
	commissionRate = 10;
	descr = <div style='padding:10px'><div style="padding:10px"><p>测试普通产品测试普通产品测试普通产品测试普通产品</p></div></div>;
	classNames = 普通商品;
	createAt = 1474340764;
	initNum = 0;
	isRepair = 0;
	shippingFee = 12;
	skuSelected = [{"propList":["白色"],"text":"颜色"},{"propList":["10"],"text":"尺码"}];
	videoPath = ;
	sort = 0;
	bonusRate = 0;
	adImage = http://test.image.shuangkuai.co/resources/6dfc0685-685f-4b8c-b756-a9358bde1038;
	createNum = 0;
	joinNum = 2;
	endTime = 1475078400;
	minLimitNum = 2;
	groupbuyStatus = 1;
	sku = [{"propList":["白色","黑色"],"text":"颜色"},{"propList":["10","11"],"text":"尺码"}];
	commissionPeriod = 7;
	companyId = unizone;
	peopleNum = 1;
	commission = 9;
	groupbuyStock = 46;
	finalPrice = 90;
	imagePath = ["http://test.image.shuangkuai.co/resources/a3e7bad0-d0b4-44ed-911a-3004530f32d0"];
	isReturnCommit = 0;
	masterId = fdd8e03d9e774c909d68ae9eb066b60e;
	price = 100;
	productName = 玫瑰金耳环;
	groupbuyPrice = 70.0-108.24;
	isInvoice = 0;
	classIds = ;
	productId = c862b223-31e5-49d1-b892-38528a167179;
 
 */

@property (nonatomic, retain) NSString *id;
//结束时间
@property (nonatomic, assign) NSInteger endTime;
//开始时间
@property (nonatomic, assign) NSInteger startTime;
//原价格
@property (nonatomic, assign) CGFloat price;
//当前价格
@property (nonatomic, assign) CGFloat finalPrice;
//公司id
@property (nonatomic, retain) NSString *companyId;

@property (nonatomic, retain) NSString *masterId;
//团购描叙
@property (nonatomic, retain) NSString *descr;

@property(nonatomic,retain)NSString *imagePath;

@property(nonatomic,retain)NSString *adImage;
//名
@property(nonatomic,retain)NSString *productName;

@property(nonatomic,retain)NSString *groupbuyPrice;
//创建时间
@property(nonatomic,assign)NSInteger createAt ;
//最近更改时间
@property(nonatomic,assign)NSInteger lastUpdate ;
//拼团状态
@property(nonatomic,assign)NSInteger groupbuyStatus;

@property(nonatomic,copy)NSString *productId ;

@property(nonatomic,retain)NSString *classNames;

@property(nonatomic,assign)NSInteger shippingFee;

@property(nonatomic,assign)NSInteger joinNum;

@property(nonatomic,assign)NSInteger minLimitNum;

@property(nonatomic,assign)NSInteger peopleNum;
@end
