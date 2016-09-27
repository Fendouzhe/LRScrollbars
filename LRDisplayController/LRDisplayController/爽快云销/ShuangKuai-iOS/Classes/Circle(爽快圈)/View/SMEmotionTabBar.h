//
//  SMEmotionTabBar.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SMEmotionTabBarButtonTypeRecent, // 最近
    SMEmotionTabBarButtonTypeDefault, // 默认
    SMEmotionTabBarButtonTypeEmoji, // emoji
    SMEmotionTabBarButtonTypeLxh, // 浪小花
} SMEmotionTabBarButtonType;

@class SMEmotionTabBar;
@protocol SMEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(SMEmotionTabBar *)tabBar didSelectButton:(SMEmotionTabBarButtonType)buttonType;
@end


@interface SMEmotionTabBar : UIView

@property (nonatomic, weak) id<SMEmotionTabBarDelegate> delegate;

@end
