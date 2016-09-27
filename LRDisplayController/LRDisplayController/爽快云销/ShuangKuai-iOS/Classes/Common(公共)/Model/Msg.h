//
//  Msg.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Msg : NSObject

@property (nonatomic, retain) NSString *content;

@property (nonatomic, assign) NSInteger createAt;

@property (nonatomic, assign) NSInteger isSite;

@property(nonatomic,retain)NSNumber * messageId;
@property(nonatomic,retain)NSObject *body;
@property(nonatomic,copy)NSString * subject;
@property(nonatomic,assign)NSInteger sendTime;
@property(nonatomic,assign)NSInteger type;


@end
