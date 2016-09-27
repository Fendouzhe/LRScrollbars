//
//  SMCity.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCity.h"

@implementation SMCity

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)cityWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
