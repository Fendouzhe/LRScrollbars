//
//  SMGroupChatList.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMGroupChatList : NSObject
@property (nonatomic,strong,readonly) NSArray *groupArray;/**< 群聊群组,SMGroupChatListData */
@property (nonatomic,assign,readonly) BOOL isGetValue;/**< 是否获取过值 */
+(instancetype)sharedManager;
-(void)startWithGroupArray:(NSArray *)groupArray;
@end
