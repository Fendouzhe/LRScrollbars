//
//  SMFriendList.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMFriendList.h"

@implementation SMFriendList
+(instancetype)sharedManager {
    
    static SMFriendList *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

-(void)startWithFriendsArray:(NSArray *)friendsArray{
    _friendsArray = friendsArray;
    _isGetValue = YES;
}

@end
