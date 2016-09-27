//
//  PromotionMaster.h
//  ShuangKuai-iOS
//
//  Created by Changeden on 16/7/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionMaster : NSObject

@property (nonatomic, retain) NSString *id;
//活动名称
@property (nonatomic, retain) NSString *name;
//活动地址
@property (nonatomic, retain) NSString *address;
//活动开始时间
@property(nonatomic,assign)NSInteger startTime;
//活动结束时间
@property(nonatomic,assign)NSInteger endTime;
//活动海报
@property (nonatomic, retain) NSString *posterImage;
//活动主题
@property (nonatomic, retain) NSString *theme;
//活动形式
@property (nonatomic, retain) NSString *form;
//活动标签
@property (nonatomic, retain) NSString *tag;
//是否设置为隐私
@property(nonatomic,assign)NSInteger isPrivate;
//详细内容
@property (nonatomic, retain) NSString *content;
//活动状态
@property(nonatomic,assign)NSInteger status;
//活动收费类型（免费  收费  复合）
@property (nonatomic, retain) NSString *chargeType;
//活动票价(显示活动页面)
//@property(nonatomic,retain)NSNumber *price;
//活动票价(显示活动页面)
@property(nonatomic,copy)NSString *price;
//排序
@property(nonatomic,assign)NSInteger sort;
//活动创建时间
@property(nonatomic,assign)NSInteger createAt;
//最近更新时间
@property(nonatomic,assign)NSInteger lastUpdate;
//企业Id
@property(nonatomic,retain)NSString *companyId;

/*
 //活动票价(显示活动页面)
 private Double price;
 //排序
 private Integer sort;
 //活动创建时间
 private Long createAt;
 //最近更新时间
 private Long lastUpdate;
 //企业Id
 private String companyId;
 
 //活动名称
 private String name;
 //活动地址
 private String address;
 //活动开始时间
 private Long startTime ;
 //活动结束时间
 private Long endTime ;
 //活动海报
 private String posterImage;
 //活动主题
 private String theme;
 //活动形式
 private String form;
 //活动标签
 private String tag;
 //是否设置为隐私
 private Integer isPrivate;
 //详细内容
 private String content;
 //活动状态
 private Integer status;
 //活动收费类型（免费  收费  复合）
 private String chargeType;
 
 */

@end
