//
//  Company.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject <NSCoding>

@property (nonatomic, retain) NSString *id;

@property (nonatomic, assign) NSInteger createAt;

@property (nonatomic, retain) NSString *descr;
/**
 *  当成简称，登录成功后拿到这歌作为首页 导航栏title
 */
@property (nonatomic, retain) NSString *engName;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) NSInteger followers;
//若有此字段则表示自己有关注该企业
@property (nonatomic, assign) NSInteger isFollow;

@property (nonatomic, assign) NSInteger lastUpdate;
/**
 *  公司规模
 */
@property (nonatomic, retain) NSString *scale;
/**
 *  图片
 */
@property (nonatomic, retain) NSString *logoPath;

@end
