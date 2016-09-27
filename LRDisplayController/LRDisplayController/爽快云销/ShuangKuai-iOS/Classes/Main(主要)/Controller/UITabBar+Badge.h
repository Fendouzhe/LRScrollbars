//
//  UITabBar+Badge.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)


-(void)showBadgeOnItemIndex:(int)index;  //显示小红点

-(void)hideBadgeOnItemIndex:(int)index; //隐藏小红点


@end
