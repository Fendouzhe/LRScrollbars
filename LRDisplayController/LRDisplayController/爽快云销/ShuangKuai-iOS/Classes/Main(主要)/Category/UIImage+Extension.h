//
//  UIImage+Extension.h
//  01-QQ聊天
//
//  Created by Apple on 15/6/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名字返回一张缩放过图片
 */
+(UIImage *)resizableImageWithName:(NSString *)imageName;

- (UIImage *)scaleToSize:(CGSize)size;
//缩小一半
- (UIImage *)scaleToHalfSize;
@end
