//
//  Schedule.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property (nonatomic, retain) NSString *id;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger createAt;

@property (nonatomic, assign) NSInteger lastUpdate;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) NSInteger remindTime;

@property (nonatomic, assign) NSInteger schTime;

@property (nonatomic, assign) NSInteger status;  // 0 未发布  1 未完成  2 已完成

@property(nonatomic,copy)NSString * uName;

@property(nonatomic,copy)NSString * uPortrait;

@property(nonatomic,copy)NSArray * users;

@property(nonatomic,copy)NSString * userId;

@property(nonatomic,assign)NSInteger remindType;

@property(nonatomic,assign)NSInteger type;

@property (nonatomic,assign) NSInteger childSchedule;/**< 子任务数量 */

@end
