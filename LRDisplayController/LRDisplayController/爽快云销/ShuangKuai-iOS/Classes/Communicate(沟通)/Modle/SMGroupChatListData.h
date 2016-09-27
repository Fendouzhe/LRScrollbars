//
//  SMGroupChatListData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMGroupChatListData : NSObject
@property (nonatomic,assign) int peoples;/**< 人数 */
@property (nonatomic,copy) NSString *remark;/**< 群聊里的显示名称 */
@property (nonatomic,copy) NSString *roomName;/**< 房间名称 */
@property (nonatomic,copy) NSString *id;/**< 房间ID,targertID */
@property (nonatomic,copy) NSString *createrId;/**< 创建者ID */
@property (nonatomic,copy) NSString *imageUrl;/**< 图像网址 */
@property (nonatomic,copy) NSString *createAt;/**< 创建时间 */
@property (nonatomic,copy) NSString *intro;/**< 群公告 */
@property (nonatomic,copy) NSString *createrName;/**< 创建者名字 */
@property (nonatomic,copy) NSString *lastUpdate;/**< 更新时间 */
@property (nonatomic,copy) NSString *messageStatus;/**< 消息状态 0 代表免打扰，1代表正常接收 */
//@property (nonatomic,strong) NSArray *chatroomMemberList;/**< 群聊人信息,chatroomMemberListData */
@end
