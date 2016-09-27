//
//  PushModel.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushModel : NSObject

/**
 全部产品界面的排序
 */
typedef enum {
    PushType_Tweet, //爽快圈
    PushType_Tweet_Comment, //爽快圈评论
    PushType_Tweet_Upvote, //爽快圈点赞
    PushType_Tweet_Repost, //爽快圈转发
    New_Order,//新的订单
    Someone_Logined, //账号在别的地方登陆
    Request_Friend //加为好友请求
} PUSH_TYPE;
//推送类型
@property (nonatomic, assign) NSInteger type;
//描述---请使用这个
@property (nonatomic, copy) NSString *mydescription;
//描述---与系统方法冲突请使用mydescription
@property (nonatomic, copy) NSString *description;
//推送的内容体
@property (nonatomic, copy) NSString *body;
//和推送相关的消息id
@property (nonatomic, assign) NSInteger messageId;
//和推送相关消息发送的时间
@property (nonatomic, assign) NSInteger sendTime;

@end
