//
//  SMProvince.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMCity;

@interface SMProvince : NSObject

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,strong)NSArray *sub;

@property (nonatomic ,strong)SMCity *city;

-(instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)provinceWithCity:(SMCity *)city;

@end
