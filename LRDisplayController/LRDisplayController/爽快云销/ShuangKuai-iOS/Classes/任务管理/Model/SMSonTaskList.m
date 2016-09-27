//
//  SMSonTaskList.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSonTaskList.h"
#import "SMParticipant.h"

@implementation SMSonTaskList

+ (NSDictionary *)objectClassInArray{
    return @{
             @"childUser" : [SMParticipant class],
             };
}


+ (Class)objectClassInArray:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"childUser"]) {
        return [SMParticipant class];
    }
    return nil;
}

@end
