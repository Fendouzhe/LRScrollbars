//
//  SingtonManager.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SingtonManager.h"

@implementation SingtonManager


+ (SingtonManager *)sharedManager
{
    static SingtonManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(instancetype)init{
    self = [super init];
    self.orderNum = 0;
    self.friendNum = 0;
    self.jobNum = 0;
    return self;
}

-(NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

-(NSMutableArray *)friendArray{
    if (!_friendArray) {
        _friendArray = [NSMutableArray array];
    }
    return _friendArray;
}

-(NSMutableArray *)jobArray{
    if (!_jobArray) {
        _jobArray = [NSMutableArray array];
    }
    return _jobArray;
}

-(NSMutableArray *)taskArray{
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}
-(void)initial{
    [self.orderArray removeAllObjects];
    [self.friendArray removeAllObjects];
    [self.jobArray removeAllObjects];
    [self.taskArray removeAllObjects];
//    _orderNum = 0;
//    _friendNum = 0;
//    _jobNum = 0;
}
@end
