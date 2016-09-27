//
//  NSObject_User.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCopying>
/**
 *  名字
 */
@property (nonatomic, copy) NSString *name;
/**
 * 性别
 final static Integer SEX_UNKNOWN = 0;//未知姓别
	final static Integer SEX_MALE = 1;//男
	final static Integer SEX_FEMALE = 2;//女
 */
@property (nonatomic, assign) NSInteger gender;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) NSString *email;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  头像,一个地址
 */
@property (nonatomic, copy) NSString *portrait;
/**
 *  唯一标识符
 */
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *id;
//简介
@property (nonatomic, copy) NSString *intro;
/**
 *  暂可不用
 */
@property (nonatomic, copy) NSString *wxid;

@property (nonatomic, copy) NSString *bankCard;

@property (nonatomic, copy) NSString *createAt;

@property (nonatomic, copy) NSNumber *commission;
/**
 *  暂可不用
 */
@property (nonatomic, copy) NSData *imagePortrait;

/**
 *  是否验证过
 */
@property (nonatomic, readwrite, assign) BOOL isAuthenticated;

//关注的企业数
@property (nonatomic, assign) NSInteger follows;

//发表的爽快圈数
@property (nonatomic, assign) NSInteger tweets;
//leancloud的标识key
@property (nonatomic, copy) NSString *rtcKey;

//所在地址
@property (nonatomic, copy) NSString *address;

//固定电话
@property (nonatomic, copy) NSString *telephone;

//公司信息
@property (nonatomic, copy) NSString *companyName;

//公司id
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, copy) NSString *companyEngName;

//好友关系 0为非好友 1为好友 
@property (nonatomic, assign) NSInteger relation;
/**
 *  排行业绩
 */
@property (nonatomic,copy) NSString * sumMoney;
/**
 * 名字第一个字的拼音首写字母
 */
@property (nonatomic ,copy) NSString *sort;
//行业
@property (nonatomic ,copy) NSString *induTag;

//是否签订协议  1已签   0未签
@property (nonatomic, assign) NSInteger isSigned;

//我的上级ID
@property (nonatomic, copy) NSString *bossId;
//是否二级销售
@property (nonatomic, assign) NSInteger level2;

@property (nonatomic,assign)BOOL isSelect;
//是否为朋友
@property (nonatomic,assign)BOOL isFriend;

//工作号码
@property (nonatomic, copy) NSString *workPhone;

//用来作为聊天帐号的字符串
@property (nonatomic ,copy)NSString *rcToken;

@property (nonatomic ,copy)NSString *companyLogoPath;/**< 公司logo */
//启动背景图
@property (nonatomic, copy)NSString *appLoginBg;

//启动视频
@property (nonatomic, copy)NSString *appLoginVideo;

@end
