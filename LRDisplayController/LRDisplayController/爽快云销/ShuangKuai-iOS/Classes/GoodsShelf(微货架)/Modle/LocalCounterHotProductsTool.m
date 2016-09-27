//
//  LocalCounterHotProductsTool.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "LocalCounterHotProductsTool.h"
#import "FavoritesDetail.h"

@implementation LocalCounterHotProductsTool

static FMDatabase *_fmdb;

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];

    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_counterHotProducts(id INTEGER PRIMARY KEY, adImage TEXT NOT NULL, itemName TEXT NOT NULL, value2 DOUBLE NOT NULL);"];
}

+ (BOOL)insertModal:(FavoritesDetail *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_counterHotProducts(adImage, itemName, value2) VALUES ('%@', '%@', '%.2f');", modal.adImage, modal.itemName, modal.value2.doubleValue];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_counterHotProducts;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *adImage = [set stringForColumn:@"adImage"];
        NSString *itemName = [set stringForColumn:@"itemName"];
        NSNumber *value2 = [NSNumber numberWithDouble:[set doubleForColumn:@"value2"]];
        
        FavoritesDetail *modal = [FavoritesDetail modalWithAdimage:adImage itemName:itemName currentPrice:value2];
        [arrM addObject:modal];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_counterHotProducts";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_counterHotProducts SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}

@end
