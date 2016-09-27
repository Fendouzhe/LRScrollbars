//
//  LocalHotProductTool.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "LocalHotProductTool.h"

static FMDatabase *_fmdb;

@implementation LocalHotProductTool

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    SMLog(@"filePath   %@",filePath);
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_HotProduct(id INTEGER PRIMARY KEY, adImage TEXT NOT NULL);"];
}

+ (BOOL)insertModal:(Product *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_HotProduct(adImage) VALUES ('%@');", modal.adImage];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_HotProduct;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *adImage = [set stringForColumn:@"adImage"];
        
        Product *modal = [Product modelWithAdImage:adImage];
        [arrM addObject:modal];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_HotProduct";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_HotProduct SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}


@end
