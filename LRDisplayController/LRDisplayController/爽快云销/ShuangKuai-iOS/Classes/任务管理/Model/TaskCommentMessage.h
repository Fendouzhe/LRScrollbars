//
//  TaskCommentMessage.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskCommentMessage : NSObject
@property (nonatomic,copy) NSString *content;/**< <#属性#> */
@property (nonatomic,assign) NSInteger createAt;/**< <#属性#> */
@property (nonatomic,copy) NSString *id;/**< 评论ID */
@property (nonatomic,copy) NSString *scheduleId;/**< 任务ID */
@property (nonatomic,copy) NSString *uName;/**< <#属性#> */
@property (nonatomic,copy) NSString *uPortrait;/**< <#属性#> */
@property (nonatomic,copy) NSString *userId;/**< id */
@end
