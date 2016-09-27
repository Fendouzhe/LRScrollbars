//
//  BXBadgeView.m
//  IrregularTabBar
//
//  Created by leilurong on 16/5/31.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "BXBadgeView.h"

#define wh 10

@implementation BXBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[UIImage resizableImageWithName:@"main_badge"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 按钮的高度就是背景图片的高度
        //self.height = self.currentBackgroundImage.size.height;
        self.height = wh;
    }
    return self;
}


#warning 需要修改红点尺寸位置在这里修改
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
//    self.hidden = NO;
//    if ([badgeValue integerValue] > 99) {
//        badgeValue = @"...";
//    } else if ([badgeValue integerValue] <= 0) {
//        badgeValue = nil;
//        self.hidden = YES;
//    }
//    // 设置文字
//    [self setTitle:badgeValue forState:UIControlStateNormal];
//    
//    // 根据文字计算自己的尺寸
//    CGFloat bgW = self.currentBackgroundImage.size.width;
//   
//    self.width = bgW;
//    if (badgeValue.length > 1) {
//        self.width = 26;
//    }
    
    self.hidden = NO;
    if ([badgeValue integerValue] <= 0) {
        badgeValue = nil;
        self.hidden = YES;
    }else{
        //设置框
        self.width = wh;

    }
}

@end
