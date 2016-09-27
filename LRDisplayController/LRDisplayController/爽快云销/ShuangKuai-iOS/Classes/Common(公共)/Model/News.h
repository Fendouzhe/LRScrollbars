//
//  News.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, retain) NSString *companyId;
/**
 *  内容
 */
@property (nonatomic, retain) NSString *content;
/**
 *  新闻标题
 */
@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) NSInteger createAt;

@property (nonatomic, retain) NSString *id;

@property (nonatomic, assign) NSInteger lastUpdate;

@property (nonatomic, retain) NSString *imagePaths;

@end
