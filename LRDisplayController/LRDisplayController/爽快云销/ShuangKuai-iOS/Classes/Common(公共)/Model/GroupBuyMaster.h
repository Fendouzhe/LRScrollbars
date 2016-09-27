//
//  GroupBuyMaster.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuyMaster : NSObject

/*
    status = 1;
	productAmount = 0;
	activeTag = ;
	shareTitle = ;
	createAt = 1474340734;
	companyId = unizone;
	endTime = 1475078400;
	lastUpdate = 1474340734;
	name = 拼团F;
	buyNum = 13;
	autoCloseTime = 0;
	id = fdd8e03d9e774c909d68ae9eb066b60e;
	shareProfile = ;
	companyName = 广州宇中网络科技有限公司;
	imagePath = http://test.image.shuangkuai.co/resources/84ea1d86f1d24ae383e1fbecbdf5d944;
	isAutoJudge = 0;
	descr = ;
	salesVolume = 0;
	validTimeHour = 0;
	startTime = 1474300800;
 
 */

@property (nonatomic, retain) NSString *id;
//订单自动关闭时间(分钟)
@property (nonatomic, assign) NSInteger autoCloseTime;
//结束时间
@property (nonatomic, assign) NSInteger endTime;
//开始时间
@property (nonatomic, assign) NSInteger startTime;
//成团有效时间
@property(nonatomic,assign) NSInteger validTimeHour;
//活动标签
@property (nonatomic, retain) NSString *activeTag;
//公司id
@property (nonatomic, retain) NSString *companyId;
//公司名
@property (nonatomic, retain) NSString *companyName;
//团购描叙
@property (nonatomic, retain) NSString *descr;
//团购图片
@property(nonatomic,retain)NSString *imagePath;
//团购名
@property(nonatomic,retain)NSString *name;
//分享简介
@property(nonatomic,retain)NSString *shareProfile;
//分享标题
@property(nonatomic,retain)NSString *shareTitle;
//是否自动判断成团条件
@property(nonatomic,assign)NSInteger isAutoJudge;
//创建时间
@property(nonatomic,assign)NSInteger createAt ;
//最近更改时间
@property(nonatomic,assign)NSInteger lastUpdate ;
//活动商品数量
@property(nonatomic,assign)NSInteger productAmount;
//参与总人数
@property(nonatomic,assign)NSInteger buyNum ;
//总销量
@property(nonatomic,assign)NSInteger salesVolume;
//活动状态
@property(nonatomic,assign)NSInteger status;

@property (nonatomic ,assign)NSInteger clickState;/**< 1，活动未开始 2，活动正在进行 3，活动已结束 。可以通过活动的开始时间来判断正处于哪个状态，从而更新UI的显示和点击cell后的处理*/

@end
