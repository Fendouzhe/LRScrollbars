//
//  MainTaskParticipant.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTaskParticipant : NSObject
@property (nonatomic,copy) NSString *name;/**< 名字 */
@property (nonatomic,copy) NSString *id;/**< 参与人的id */
@property (nonatomic,copy) NSString *iconUrl;/**< 头像网址 */
@end
