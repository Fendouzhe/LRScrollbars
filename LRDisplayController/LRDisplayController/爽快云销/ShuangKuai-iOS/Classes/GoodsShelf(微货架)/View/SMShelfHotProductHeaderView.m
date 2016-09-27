//
//  SMShelfHotProductHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfHotProductHeaderView.h"

@interface SMShelfHotProductHeaderView ()

@property (nonatomic ,strong)UILabel *leftLabel;

@property (nonatomic ,strong)UIButton *rightBtn;

@end

@implementation SMShelfHotProductHeaderView

+ (instancetype)shelfHotProductHeaderView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = KDefaultFontBig;
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.text = @"热销商品";
        self.leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [self addSubview:rightBtn];
        self.rightBtn = rightBtn;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFontBig;
        dict[NSForegroundColorAttributeName] = KRedColorLight;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"更多商品" attributes:dict];
        [rightBtn setAttributedTitle:title forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return self;
}

- (void)rightBtnClick{
    if ([self.delegate respondsToSelector:@selector(rightBtnDidClick)]) {
        [self.delegate rightBtnDidClick];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.equalTo(@100);
    }];
}

@end
