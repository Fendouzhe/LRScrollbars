//
//  SingtonManager.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingtonManager : NSObject

+ (SingtonManager *)sharedManager;


@property(nonatomic,assign)NSInteger orderNum;

@property(nonatomic,assign)NSInteger friendNum;

@property(nonatomic,assign)NSInteger jobNum;

@property(nonatomic,assign)NSInteger taskNum;

//未读消息的数组
//订单
@property(nonatomic,copy)NSMutableArray * orderArray;
//好友请求
@property(nonatomic,copy)NSMutableArray * friendArray;
//团队任务
@property(nonatomic,copy)NSMutableArray * jobArray;

@property(nonatomic,copy)NSMutableArray * taskArray;
//将所有属性直接初始化
-(void)initial;

@end
