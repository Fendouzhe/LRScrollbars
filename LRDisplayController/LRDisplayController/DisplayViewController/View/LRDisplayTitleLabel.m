//
//  LRDisplayTitleLabel.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRDisplayTitleLabel.h"

@implementation LRDisplayTitleLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    //绘制到当前label的宽度
    rect.size.width = rect.size.width * _progress;
    //向当前绘图环境所创建的内存中的label图片上填充一个矩形，绘制使用指定的混合模式。
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    //通知重绘,会自动调用(void)drawRect:(CGRect)rect方法
    [self setNeedsDisplay];
}
@end
