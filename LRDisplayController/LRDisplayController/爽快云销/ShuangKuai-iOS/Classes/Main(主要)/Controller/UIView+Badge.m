//
//  UIView+Badge.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "UIView+Badge.h"

#define BageTag 888

@implementation UIView (Badge)


-(void)showBadgeWith:(NSString *)BadgeVulue{
    UILabel * badgeLable = [[UILabel alloc]init];
    
    //badgeLable.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    CGFloat iconWH = 0.0;
    if (isIPhone5) {
        iconWH = 46;
    }else if (isIPhone6){
        iconWH = 46 *KMatch6;
    }else if (isIPhone6p){
        iconWH = 46 *KMatch6p;
    }
    
    CGFloat marginTop = KScreenWidth / 3.0 / 3.0 / 2.0;
    
    [badgeLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
    badgeLable.layer.masksToBounds = YES;
    badgeLable.backgroundColor = [UIColor redColor];
    badgeLable.text = BadgeVulue;
    badgeLable.textColor = [UIColor whiteColor];
    badgeLable.textAlignment = NSTextAlignmentCenter;
    badgeLable.font = [UIFont systemFontOfSize:10];
    badgeLable.tag = BageTag;
    
    badgeLable.width = 15+(4*(BadgeVulue.length-1));
    badgeLable.height = 15;
//    badgeLable.origin = CGPointMake(self.frame.size.width/2+iconWH/2-badgeLable.width/2,marginTop);
    badgeLable.x = CGRectGetMaxX(self.bounds) / 4 * 3;
    badgeLable.y = 0;
    
    badgeLable.layer.cornerRadius = 7.5;
    
    [self addSubview:badgeLable];
}

-(void)showBadge{
//    for (UIView * view in self.subviews) {
//        if ([view isKindOfClass:[UILabel class]]) {
//            [view removeFromSuperview];
//        }
//    }

    [[self viewWithTag:BageTag] removeFromSuperview];
    //显示
    UILabel * badgeLable = [[UILabel alloc]init];
    badgeLable.backgroundColor = [UIColor redColor];
    badgeLable.tag = BageTag;
    CGFloat width = 8;
    badgeLable.width = width;
    badgeLable.height = width;
    badgeLable.x = self.width - width - 25;
    badgeLable.y = 0 + 2;
    badgeLable.layer.cornerRadius = width * 0.5;
    badgeLable.layer.masksToBounds = YES;
    badgeLable.layer.shouldRasterize = YES;
    [self addSubview:badgeLable];
}

-(void)removeBadge{
    UILabel * label = [self viewWithTag:BageTag];
    [label removeFromSuperview];
}
@end
