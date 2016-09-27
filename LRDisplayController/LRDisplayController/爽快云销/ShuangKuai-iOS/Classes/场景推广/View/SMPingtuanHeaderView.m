//
//  SMPingtuanHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPingtuanHeaderView.h"

@interface SMPingtuanHeaderView()

@property(nonatomic, strong)UILabel *titleLabel;

@end

@implementation SMPingtuanHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat labelWidth = KScreenWidth/3 + 20;
        UILabel *tipLabel = [[UILabel alloc] init];
        [self addSubview:tipLabel];
        self.titleLabel = tipLabel;
        //tipLabel.text = @"特价";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        UIColor *color = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:184/255.0 alpha:0.7];
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.font = [UIFont systemFontOfSize:14*KMatch];
    
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(@28);
            make.width.equalTo(@(labelWidth));
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        [self addSubview:leftLine];
        leftLine.backgroundColor = color;
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipLabel.mas_left).offset(0);
            make.centerY.equalTo(tipLabel.mas_centerY);
            make.height.equalTo(@0.8);
            make.width.equalTo(@(labelWidth-55));
        }];
        
        UIView *rightLine = [[UIView alloc] init];
        [self addSubview:rightLine];
        rightLine.backgroundColor = color;
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(0);
            make.centerY.equalTo(tipLabel.mas_centerY);
            make.height.equalTo(@0.8);
            make.width.equalTo(@(labelWidth-55));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
