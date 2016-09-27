//
//  NSString+Extension.h
//  01-QQ聊天
//
//  Created by Apple on 15/6/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 *  计算字符串实际占据的区域
 */
-(CGSize)textSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
