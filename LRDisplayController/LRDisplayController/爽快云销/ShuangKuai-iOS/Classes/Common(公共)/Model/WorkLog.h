//
//  WorkLog.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkLog : NSObject

@property (nonatomic, retain) NSString *id;

@property (nonatomic, retain) NSString *content;

@property (nonatomic, retain) NSString *createAt;

@property (nonatomic, retain) NSString *lastUpdate;

/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;

@property (nonatomic, retain) NSString *title;

//头像
@property (nonatomic ,copy)NSString *portrait;

//名字
@property (nonatomic ,copy)NSString *userName;
@end
