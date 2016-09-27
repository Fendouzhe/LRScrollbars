//
//  Classify.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classify : NSObject


@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, retain) NSNumber *sort;


@end
