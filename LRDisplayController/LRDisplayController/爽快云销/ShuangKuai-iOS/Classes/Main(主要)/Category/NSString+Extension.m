//
//  NSString+Extension.m
//  01-QQ聊天
//
//  Created by Apple on 15/6/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(CGSize)textSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
