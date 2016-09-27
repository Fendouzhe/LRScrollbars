//
//  BXTabBarButton.h
//  IrregularTabBar
//
//  Created by leilurong on 16/5/3.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTabBarButton : UIButton
/** 模型数据 */
@property (nonatomic, strong) UITabBarItem *item;

/** 提醒数字 */
@property (nonatomic, copy) NSString *badgeValue;
@end
