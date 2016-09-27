//
//  SMDiscoverBottomHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDiscoverBottomHeaderView : UIView

@property (nonatomic ,strong)UIButton *news;

+ (instancetype)discoverBottomHeaderView;

- (void)newsClick:(UIButton *)btn;

@end
