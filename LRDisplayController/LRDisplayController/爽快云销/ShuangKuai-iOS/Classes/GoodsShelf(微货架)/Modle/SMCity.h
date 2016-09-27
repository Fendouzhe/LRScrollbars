//
//  SMCity.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCity : NSObject

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,strong)NSArray *sub;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)cityWithDict:(NSDictionary *)dict;

@end
