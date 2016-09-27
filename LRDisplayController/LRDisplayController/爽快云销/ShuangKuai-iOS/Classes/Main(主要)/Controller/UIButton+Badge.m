//
//  UIButton+Badge.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "UIButton+Badge.h"

@implementation UIButton (Badge)

-(void)showBadgeWith:(NSString *)BadgeVulue{
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //显示
    UILabel * badgeLable = [[UILabel alloc]init];
    
    //badgeLable.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    
    [badgeLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
    badgeLable.backgroundColor = [UIColor redColor];
    badgeLable.text = BadgeVulue;
    badgeLable.textColor = [UIColor whiteColor];
    badgeLable.textAlignment = NSTextAlignmentCenter;
    badgeLable.font = [UIFont systemFontOfSize:10];
    badgeLable.tag = 10;
    badgeLable.width = 15+(4*(BadgeVulue.length-1));
    badgeLable.height = 15;
//    badgeLable.origin = CGPointMake(self.frame.size.width-5-2.5*(BadgeVulue.length-1),-5);
    badgeLable.x = 0;
    badgeLable.y = 0;
    badgeLable.layer.cornerRadius = 7.5;
    badgeLable.layer.masksToBounds = YES;

    
    [self addSubview:badgeLable];
   
}

-(void)showButtonBadge{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    //显示
    UILabel * badgeLable = [[UILabel alloc]init];
    badgeLable.backgroundColor = [UIColor redColor];
    badgeLable.tag = 10;
    CGFloat width = 8;
    badgeLable.width = width;
    badgeLable.height = width;
    badgeLable.x = self.width-6;
    badgeLable.y = self.height-6;
    badgeLable.layer.cornerRadius = width*0.5;
    badgeLable.layer.masksToBounds = YES;
    
    [self addSubview:badgeLable];
}

-(void)removeBadge{
    //删除
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
}
@end
