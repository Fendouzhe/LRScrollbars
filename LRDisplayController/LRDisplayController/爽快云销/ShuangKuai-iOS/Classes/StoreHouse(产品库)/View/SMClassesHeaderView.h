//
//  SMClassesHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMClassesLevel1.h"
@class SMClassesHeaderView;

@protocol SMClassesHeaderViewDelegate <NSObject>
//查看全部按钮点击
- (void)chectAllButtonClickWithHeaderView:(SMClassesHeaderView *)view;

@end

@interface SMClassesHeaderView : UIView

@property(nonatomic, weak) id<SMClassesHeaderViewDelegate> delegate;

@property (nonatomic ,strong)SMClassesLevel1 *model1;/**< <#注释#> */

+ (instancetype)classesHeaderView;

@end
