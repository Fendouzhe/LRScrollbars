//
//  UITabBar+Badge.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0
#define ViewTag 888

@implementation UITabBar (Badge)


//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    CGFloat width = 8;
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = ViewTag + index;
    badgeView.layer.cornerRadius = width * 0.5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, width, width);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == ViewTag+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
