//
//  SMFriendGroup.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMFriend;
@interface SMFriendGroup : NSObject

@property (nonatomic ,copy)NSString *sort;

@property (nonatomic ,strong)NSArray *arrFriend;

@property (nonatomic ,strong)SMFriend *myFriend;

@end
