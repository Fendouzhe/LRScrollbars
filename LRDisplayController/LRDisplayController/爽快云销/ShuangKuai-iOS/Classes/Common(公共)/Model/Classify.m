//
//  Classify.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "Classify.h"

@implementation Classify



-(void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:[value stringValue] forKey:key];
    }
    [super setValue:value forKey:key];
}



@end
