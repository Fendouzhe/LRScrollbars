
//
//  Const.h
//  BuDeJie
//
//  Created by LR on 15/12/5.
//  Copyright © 2015年 LR. All rights reserved.
//

#ifndef Const_h
#define Const_h

#import "LRDisplayViewController.h"

// 导航条高度
static CGFloat const LRNavBarH = 64;

// 标题滚动视图的高度
static CGFloat const LRTitleScrollViewH = LRTitleScrollViewHeight;

// 标题缩放比例
static CGFloat const LRTitleTransformScale = 1.3;

// 下划线默认高度
static CGFloat const LRUnderLineH = 2;

#define LRScreenW [UIScreen mainScreen].bounds.size.width
#define LRScreenH [UIScreen mainScreen].bounds.size.height

// 默认标题字体
#define LRTitleFont [UIFont systemFontOfSize:16]

// 默认标题间距
static CGFloat const margin = 0;//20;

static NSString * const ID = @"cell";

// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const LRDisplayViewClickOrScrollDidFinshNotice = @"LRDisplayViewClickOrScrollDidFinshNotice";

// 重复点击通知
static NSString * const LRDisplayViewRepeatClickTitleNotice = @"LRDisplayViewRepeatClickTitleNotice";


#endif /* Const_h */
