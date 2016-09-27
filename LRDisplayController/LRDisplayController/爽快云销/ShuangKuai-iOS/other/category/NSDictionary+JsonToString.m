//
//  NSDictionary+JsonToString.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "NSDictionary+JsonToString.h"

@implementation NSDictionary (JsonToString)
- (NSString*)dictionaryToJson{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
