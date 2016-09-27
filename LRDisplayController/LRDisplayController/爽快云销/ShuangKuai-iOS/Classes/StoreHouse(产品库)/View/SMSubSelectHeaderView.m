//
//  SMSubSelectHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSubSelectHeaderView.h"

@implementation SMSubSelectHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}

-(void)creatView
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"注: 一个专柜最多添加5个商品";
    label.textColor = [UIColor grayColor];
    label.font = KDefaultFontSmall;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).equalTo(@5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
}

@end
