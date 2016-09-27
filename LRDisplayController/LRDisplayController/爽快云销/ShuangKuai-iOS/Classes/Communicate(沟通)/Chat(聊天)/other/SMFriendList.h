//
//  SMFriendList.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFriendList : NSObject
@property (nonatomic,strong,readonly) NSArray *friendsArray;/**< 好友列表,User */
@property (nonatomic,assign,readonly) BOOL isGetValue;/**< 是否获取过值 */
+(instancetype)sharedManager;
-(void)startWithFriendsArray:(NSArray *)friendsArray;
@end
