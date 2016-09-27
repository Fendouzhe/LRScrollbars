//
//  Activity.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, retain) NSString *id;

@property (nonatomic, assign) NSInteger createAt;
/**
 *  活动内容
 */
@property (nonatomic, retain) NSString *content;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) NSInteger lastUpdate;

@property (nonatomic, retain) NSString *companyId;
/**
 *  开始时间
 */
@property (nonatomic, assign) NSInteger startTime;
/**
 *  结束时间
 */
@property (nonatomic, assign) NSInteger endTime;
/**
 *  活动类型
 */
@property (nonatomic, assign) NSInteger type;
/**
 *
 */
@property (nonatomic, retain) NSString *imagePaths;
/**
 *  参加人数
 */
@property (nonatomic ,assign)int peoples;

@end
