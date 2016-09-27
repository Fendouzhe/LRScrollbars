//
//  TempAppShareObject.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMGroupChatViewController;
@interface TempAppShareObject : NSObject
@property (nonatomic,strong) SMGroupChatViewController *tempGroupVC;/**< 群聊 */
+(instancetype)shareInstance;
@end
