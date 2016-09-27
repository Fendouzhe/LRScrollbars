//
//  SMGroupChatList.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatList.h"

@implementation SMGroupChatList
+(instancetype)sharedManager {
    
    static SMGroupChatList *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

-(void)startWithGroupArray:(NSArray *)groupArray{
    _groupArray = groupArray;
    _isGetValue = YES;
}
@end
