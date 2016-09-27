//
//  CustomNotView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomNotView.h"

@implementation CustomNotView

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, -44, KScreenWidth, 44);
        self.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:0.9];
        UIWindow * widow = [[UIApplication sharedApplication].windows lastObject];
        [widow addSubview:self];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.frame = CGRectMake(0, 0, KScreenWidth, 44);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.5 animations:^{
                    //self.alpha = 0;
                    self.frame = CGRectMake(0, -44, KScreenWidth, 44);
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            });
        }];
    }
    return self;
}

-(void)showBody:(NSString * )body{
    UILabel * label = [[UILabel alloc]initWithFrame:self.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.center;
    label.textColor = [UIColor whiteColor];
    label.text = body;
    [self addSubview:label];
}

@end
