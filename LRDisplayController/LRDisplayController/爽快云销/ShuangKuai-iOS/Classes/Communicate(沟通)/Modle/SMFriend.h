//
//  SMFriend.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFriend : NSObject

/**
 *  头像,一个地址
 */
@property (nonatomic, copy)NSString *portrait;

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *sort;

@property (nonatomic ,assign) BOOL select;/**< 选择状态 */

@property (nonatomic ,strong)User *user;

@property (nonatomic ,assign)BOOL isSelected; /**< 判断是否处于选中状态 */

@end
