//
//  LocalCounterHotProductsTool.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCounterHotProductsTool : NSObject

// 插入模型数据
+ (BOOL)insertModal:(FavoritesDetail *)modal;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

@end
