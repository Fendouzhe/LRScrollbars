//
//  ChatMessageSave.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "ChatMessageSave.h"
#import <RongIMKit/RongIMKit.h>
@interface ChatMessageSave ()
@property (nonatomic,strong) FMDatabaseQueue *databaseQueue;/**< 数据库队列 */
@property (nonatomic,copy) NSString *dataPath;/**< 数据库路径 */
@end

@implementation ChatMessageSave

-(NSString *)dataPath
{
    if (_dataPath==nil) {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        _dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/textMessage",KRongTokenStr,userID]];
    }
    return _dataPath;
}

-(FMDatabaseQueue *)databaseQueue
{
    if (_databaseQueue == nil) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.dataPath];
    }
    return _databaseQueue;
}

+ (instancetype)shareInstance {
    static ChatMessageSave *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] init];
    });
    return __singletion;
}

-(instancetype)init{
    if (self = [super init]) {
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            /**
             * 数据库字段说明:
             * ID:主键，自增
             * userID:用户ID
             * DataType:文件类型,0未知;1图片;2音频（//TODO: 需要的时候再添加）
             * urlStr:文件原始的URL
             * startData:原始文件是否已经下载完成（0：未完成，1：完成）
             * endData:数据转换是否完成（0：未完成，1：完成）
             * 类型与satrtData,endData的关系
             *（0）startData=0或1,endData=0
             *（1）startData=0或1,endData=0
             *（2）startData是指amr文件，endData指的是wav文件
             * ArmWithWav:arm和wav相互转换，0为未进行转换，1为进行转换中
             */
            [db executeUpdate:@"create table IF NOT EXISTS `ChatData` (`ID` integer NOT NULL PRIMARY KEY autoincrement, tagerID varchat(40),category int(1),recevie_time DATETIME,send_time DATETIME,content varchat(255), senderID,messageDirection int(1));"];
        }];
        //        });
    }
    return self;
}

-(void)saveMessage:(RCMessage *)message{
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf.databaseQueue inDatabase:^(FMDatabase *db) {
            NSString *tagerID = message.targetId;
            NSNumber *category = [NSNumber numberWithInteger:message.conversationType];
            NSNumber *recevieTime = [NSNumber numberWithLongLong:message.receivedTime];
            NSNumber *sendTime = [NSNumber numberWithLongLong:message.sentTime];
            NSString *sendID = message.senderUserId;
            NSNumber *messageDirection = [NSNumber numberWithInt:message.messageDirection];
            NSString *content;
            if([message.content isKindOfClass:[RCTextMessage class]]) {
                RCTextMessage *txtMsg = (RCTextMessage*)message.content;
                //使用txtMsg做一些事情 ...
                SMLog(@"消息内容 = %@",txtMsg.content);
                content = txtMsg.content;
                [db executeUpdate:@"insert into ChatData  (tagerID,category,recevie_time,send_time,content,senderID,messageDirection) values (?,?,?,?,?,?,?)",tagerID,category,recevieTime,sendTime,content,sendID,messageDirection];
            }
            
        }];
    });
}

-(void)searchMessageWithKeywords:(NSString *)keyWords withSuccessBlock:(ArrayBlock)block{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserIDkey];
        NSString *sql = [NSString stringWithFormat:@"select * from ChatData where content like '%%%@%%';",keyWords];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([rs next]) {
            NSString *targetId = [rs stringForColumn:@"tagerID"];
            RCConversationType type = [rs intForColumn:@"category"];
            long long recevieTime = [rs longLongIntForColumn:@"recevie_time"];
            long long sendTime = [rs longLongIntForColumn:@"send_time"];
            NSString *content = [rs stringForColumn:@"content"];
            NSString *sendID = [rs stringForColumn:@"senderID"];
            int messageDirection = [rs intForColumn:@"messageDirection"];
            RCMessage *rcMessage = [[RCMessage alloc] init];
            rcMessage.targetId = targetId;
            rcMessage.conversationType = type;
            rcMessage.receivedTime = recevieTime;
            rcMessage.sentTime = sendTime;
            rcMessage.senderUserId = sendID;
            rcMessage.messageDirection = messageDirection;
            RCTextMessage *txtMessage = [RCTextMessage messageWithContent:content];
            rcMessage.content = txtMessage;
            [tempArray addObject:rcMessage];
        }
        [rs close];
        block(tempArray,nil);
    }];
}

@end
