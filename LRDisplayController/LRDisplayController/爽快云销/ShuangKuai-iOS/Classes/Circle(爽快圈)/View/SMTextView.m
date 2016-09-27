//
//  SMTextView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTextView.h"

@implementation SMTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //自己做自己的监听者.但是不要把自己的代理设置成自己
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChange{
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    //    _placeholder = placeholder;    
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

//这个是系统自带的方法，所以要用super
- (void)setText:(NSString *)text{
    [super setText:text];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    //如果已经有输入文字进去，那么就直接返回，不画站位文字
    if (self.hasText) {
        return;
    }
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    //如果self.placeholderColor 没有值的情况，就给他一个灰色
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

@end
