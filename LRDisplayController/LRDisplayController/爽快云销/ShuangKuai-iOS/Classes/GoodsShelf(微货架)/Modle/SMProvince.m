//
//  SMProvince.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProvince.h"
#import "SMCity.h"

@implementation SMProvince

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceWithCity:(SMCity *)city{
    
    SMProvince *province = [[self alloc] init];
    province.city = city;
    return province;
}

- (void)setCity:(SMCity *)city{
    _city = city;
    
}

@end
