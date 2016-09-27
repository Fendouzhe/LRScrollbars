//
//  SMFriend.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMFriend.h"

@implementation SMFriend

- (void)setUser:(User *)user{
    _user = user;
    self.portrait = user.portrait;
    self.name = user.name;
    self.sort = user.sort;
}


@end
