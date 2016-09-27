//
//  ChatMessageSave.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCMessage;
@interface ChatMessageSave : NSObject
+ (instancetype)shareInstance;
-(void)saveMessage:(RCMessage *)message;
-(void)searchMessageWithKeywords:(NSString *)keyWords withSuccessBlock:(ArrayBlock)block;
@end
