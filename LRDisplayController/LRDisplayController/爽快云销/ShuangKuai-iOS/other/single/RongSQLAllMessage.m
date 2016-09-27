//
//  RongSQLAllMessage.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "RongSQLAllMessage.h"

@interface RongSQLAllMessage ()
@property (nonatomic,strong) FMDatabaseQueue *databaseQueue;/**< 数据库队列 */
@property (nonatomic,strong) FMDatabase *database;/**< 数据库实例 */
@property (nonatomic,copy) NSString *dataPath;/**< 数据库路径 */
@end

@implementation RongSQLAllMessage
+(RongSQLAllMessage *)shareInstance
{
    static RongSQLAllMessage *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] init];
    });
    return __singletion;
}

-(NSString *)dataPath
{
    if (_dataPath==nil) {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        _dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/storage",KRongTokenStr,userIDStr]];
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

-(void)searchMessageWithKeyStr:(NSString *)keyStr withResult:(ArrayBlock)result{
    MJWeakSelf
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //TODO: 查询数据库
        FMResultSet *rs = [db executeQuery:@"select content from RCT_MESSAGE where "];
        if ([rs next]) {
            int startData = [rs intForColumn:@"startData"];
            int endData = [rs intForColumn:@"endData"];
            int armWithWav = [rs intForColumn:@"ArmWithWav"];
            NSArray *successArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:startData],[NSNumber numberWithInt:endData],[NSNumber numberWithInt:armWithWav], nil];
            result(successArray,nil);
            
        }else{
            
        }
        [rs close];
    }];
}

@end
