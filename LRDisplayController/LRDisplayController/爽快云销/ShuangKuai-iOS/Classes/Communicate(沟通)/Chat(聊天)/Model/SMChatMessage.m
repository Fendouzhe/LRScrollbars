//
//  SMChatMessage.m
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "SMChatMessage.h"

@implementation SMChatMessage

+(instancetype)messageWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
