//
//  RoundCornerView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "RoundCornerView.h"

@implementation RoundCornerView
-(void)drawRect:(CGRect)rect{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = SMCornerRadios;
    
    if (_roundCorner) {
        radius = _roundCorner;
    }
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    CGContextSetLineWidth(context, 1);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGFloat R, G, B;
    
    UIColor *uiColor = _lineColor;
    CGColorRef color = [uiColor CGColor];
    int numComponents = CGColorGetNumberOfComponents(color);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        R = components[0];
        G = components[1];
        B = components[2];
    }
    CGContextSetRGBStrokeColor(context, R, G, B, 1);
//    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
}
@end
