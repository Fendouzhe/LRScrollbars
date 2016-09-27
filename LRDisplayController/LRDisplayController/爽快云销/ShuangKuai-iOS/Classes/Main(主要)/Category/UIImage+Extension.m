//
//  UIImage+Extension.m
//  01-QQ聊天
//
//  Created by Apple on 15/6/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  根据图片名字返回一张缩放过图片
 */
+(UIImage *)resizableImageWithName:(NSString *)imageName{
    // 普通状态下的图片
    UIImage *normalImage = [UIImage imageNamed:imageName];
    CGFloat lefeCap = normalImage.size.width * 0.5;
    CGFloat topCap = normalImage.size.height * 0.5;
    
    /**
     *  lefeCapWith:左边多少距离不拉伸
     rightCapWith = width - leftCapWidth - 1 = 100 - 20 - 1 = 79
     topCapHeight:顶部多少距离不拉伸
     *  bottomCapHeight:底部多少距离不拉伸 = height - topCapWidth - 1 = 50 - 20 - 1 = 29
     */
    //        normalImage = [normalImage stretchableImageWithLeftCapWidth:lefeCap topCapHeight:topCap];
    // resizableImageWithCapInsets：ios5才出现方法
    return [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(topCap, lefeCap, topCap, lefeCap)];

}

- (UIImage *)scaleToSize:(CGSize)size{
    
    //1 该方法图片会变模糊
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    //返回新的改变大小后的图片
//    return scaledImage;
    
    
    //2 该方法不会变模糊
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }else {
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//缩小一半
- (UIImage *)scaleToHalfSize{
    return [self scaleToSize:CGSizeMake(self.size.width*0.5, self.size.height*0.5)];
}

@end
