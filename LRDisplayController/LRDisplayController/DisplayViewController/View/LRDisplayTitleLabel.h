//
//  LRDisplayTitleLabel.h
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRDisplayTitleLabel : UILabel

///放大系数进度值
@property (nonatomic, assign) CGFloat progress;
///填充颜色
@property (nonatomic, strong) UIColor *fillColor;

@end
