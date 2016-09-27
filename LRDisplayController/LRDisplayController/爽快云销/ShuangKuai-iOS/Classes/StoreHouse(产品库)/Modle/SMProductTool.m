//
//  SMProductTool.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductTool.h"

static FMDatabase *_fmdb;

@implementation SMProductTool

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    SMLog(@"filePath   %@",filePath);
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_my(id INTEGER PRIMARY KEY, imagePath TEXT NOT NULL, productName TEXT NOT NULL, currentPrice DOUBEL NOT NULL , originalPrice DOUBEL NOT NULL , commission DOUBEL NOT NULL );"];
}

+ (BOOL)insertModal:(Product *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_my(imagePath, productName, currentPrice , originalPrice , commission) VALUES ('%@', '%@', '%@' ,'%@' ,'%@');", modal.imagePath, modal.name, modal.finalPrice,modal.price,modal.commission];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_my;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *imagePath = [set stringForColumn:@"imagePath"];
        NSString *productName = [set stringForColumn:@"productName"];
        NSNumber *currentPrice = [NSNumber numberWithDouble:[set doubleForColumn:@"currentPrice"]];
        NSNumber *originalPrice = [NSNumber numberWithDouble:[set doubleForColumn:@"originalPrice"]];
        NSNumber *commission = [NSNumber numberWithDouble:[set doubleForColumn:@"commission"]];
        
        Product *modal = [Product modelWith:imagePath :productName :currentPrice :originalPrice :commission];
        [arrM addObject:modal];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_my";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_my SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}



@end
