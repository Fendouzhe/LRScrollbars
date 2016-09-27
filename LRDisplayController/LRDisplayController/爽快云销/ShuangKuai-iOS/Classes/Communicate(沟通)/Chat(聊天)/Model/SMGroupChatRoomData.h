//
//  SMGroupChatRoomData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMGroupChatRoomData : NSObject
@property (nonatomic,strong) NSArray *userArray;/**< 用户数组，user */
@property (nonatomic,copy) NSString *name;/**< 群聊名称 */
@property (nonatomic,copy) NSString *groupMessage;/**< 群公告 */
@property (nonatomic,copy) NSString *imageUrl;/**< 群头像 */
@end
