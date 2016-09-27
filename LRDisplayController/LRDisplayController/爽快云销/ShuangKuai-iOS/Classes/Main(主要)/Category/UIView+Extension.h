//
//  UIView+Extension.h
//  微博00
//
//  Created by iOS on 15/9/21.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

//拥有这些属性，然后在 .m文件中分别实现 setter 方法
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
//设置中心点xy
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@end
