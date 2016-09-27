//
//  UIBarButtonItem+Extension.m
//  微博00
//
//  Created by iOS on 15/9/21.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"


@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    CGFloat width = 32;
//    [btn setBackgroundImage:[[UIImage imageNamed:image] scaleToSize:CGSizeMake(width, width)] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[[UIImage imageNamed:highImage] scaleToSize:CGSizeMake(width, width)] forState:UIControlStateHighlighted];

    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    //设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];;
}

@end
