//
//  chatroomMemberListData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatroomMemberListData : NSObject

/*************************  model  ******************************/
@property (nonatomic,copy) NSString *joinAt;/**< 添加进群聊时间 */
@property (nonatomic,copy) NSString *portrait;/**< 头像 */
@property (nonatomic,copy) NSString *remark;/**< 群组中显示的名字 */
@property (nonatomic,copy) NSString *id;/**< 未知 */
@property (nonatomic,copy) NSString *roomId;/**< 房间ID */
@property (nonatomic,copy) NSString *userId;/**< 用户ID */
@property (nonatomic,copy) NSString *messageStatus;/**< 未知 */
@property (nonatomic,copy) NSString *name;/**< 名字 */



@property (nonatomic,strong) User *user;/**< 用户 */
@end
