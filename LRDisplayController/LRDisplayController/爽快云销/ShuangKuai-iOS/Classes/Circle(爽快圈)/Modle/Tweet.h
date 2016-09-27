//
//  Tweet.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger id;
//用户id
@property (nonatomic, retain) NSString *userId;
//用户名
@property (nonatomic, retain) NSString *userName;
//点赞数量
@property (nonatomic, assign) NSInteger upvotes;
//评论数量
@property (nonatomic, assign) NSInteger comments;
//转发数量
@property (nonatomic, assign) NSInteger reposts;
//保留属性
@property (nonatomic, assign) NSInteger type;
//地址信息  定位的位置
@property (nonatomic, retain) NSString *address;
//头像
@property (nonatomic, retain) NSString *portrait;
//发布时间
@property (nonatomic, assign) NSInteger createAt;
//原贴的内容
@property (nonatomic, retain) NSString *repostFrom;
//内容
@property (nonatomic, retain) NSString *content;
//图片数组和以后可以是视频的数组
@property (nonatomic, retain) NSArray *datas;
//原贴的id，  
@property (nonatomic, retain) NSString *repostFromId;
//(自己)是否点过赞 1是 0否
@property (nonatomic, assign) NSInteger isUpvote;
@end
