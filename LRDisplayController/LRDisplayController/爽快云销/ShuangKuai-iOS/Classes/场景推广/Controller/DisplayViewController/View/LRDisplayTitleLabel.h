//
//  LRDisplayTitleLabel.h
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface LRDisplayTitleLabel : UILabel
@interface LRDisplayTitleLabel : UIView //项目需求改成 UIView

///放大系数进度值
@property (nonatomic, assign) CGFloat progress;
///填充颜色
@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIImage *image;


-(void)showBadge;

-(void)removeBadge;

+ (instancetype)displayTitleLabel;

@end
