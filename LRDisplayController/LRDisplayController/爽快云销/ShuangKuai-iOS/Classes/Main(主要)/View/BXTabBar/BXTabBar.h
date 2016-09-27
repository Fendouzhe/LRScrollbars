//
//  BXTabBar.h
//  IrregularTabBar
//
//  Created by leilurong on 16/5/3.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXTabBar;
@protocol BXTabBarDelegate <NSObject>

@optional
- (void)tabBar:(BXTabBar *)tabBar didClickBtn:(NSInteger)index;

@end

@interface BXTabBar : UIView
/** 选中的索引 */
@property (nonatomic, assign) NSInteger seletedIndex;

// 模型数组(UITabBarItem)
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<BXTabBarDelegate> delegate;


@end
