//
//  TweetComment.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetComment : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, retain) NSString *userId;

@property (nonatomic, assign) NSInteger tweetId;

@property (nonatomic, retain) NSString *content;

@property (nonatomic, assign) NSInteger createAt;

@property (nonatomic, assign) NSInteger toCommentId;

@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *portrait;

@end
