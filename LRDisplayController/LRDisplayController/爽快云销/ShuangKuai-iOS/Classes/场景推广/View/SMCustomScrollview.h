//
//  SMCustomScrollview.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomScrollview : UIView

@property (nonatomic,strong) UIScrollView *scrollview;

/**
 * 自定义初始化方法
 **/
- (id)initWithFrame:(CGRect)frame target:(id<UIScrollViewDelegate>)target;

/**
 * 加载本地图片
 **/
- (void)loadImages:(NSArray *)array;

/**
 * 加载网络图片
 **/
- (void)loadImagesWithUrl:(NSArray *)array;

/**
 * 滑动时抽屉效果
 **/
- (void)scroll;

@end
