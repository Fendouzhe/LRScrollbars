//
//  SMHomePageCollectionCell5.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell5.h"

@interface SMHomePageCollectionCell5 ()

@property (nonatomic ,strong)UIView *topView;/**< 最上面的一条横线 */

@property (nonatomic ,strong)UIButton *moreBtn;/**< 更多 按钮 */

@end

@implementation SMHomePageCollectionCell5

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.topView = [[UIView alloc] init];
        [self.contentView addSubview:self.topView];
        self.topView.backgroundColor = [UIColor lightGrayColor];
        self.topView.alpha = 0.2;
        
        self.moreBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.moreBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFontSmall;
        dict[NSForegroundColorAttributeName] = KRedColorLight;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" 更多" attributes:dict];
        [self.moreBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [self.moreBtn setAttributedTitle:str forState:UIControlStateNormal];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@" 收起" attributes:dict];
        [self.moreBtn setAttributedTitle:str2 forState:UIControlStateSelected];
        [self.moreBtn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
        [self.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)moreBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(moreBtnDidClick:)]) {
        [self.delegate moreBtnDidClick:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(@0.7);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
}

@end
