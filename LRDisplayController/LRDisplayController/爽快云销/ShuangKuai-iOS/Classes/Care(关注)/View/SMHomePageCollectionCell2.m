//
//  SMHomePageCollectionCell2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell2.h"

@interface SMHomePageCollectionCell2 ()

@property (nonatomic ,strong)UIView *topView;/**< 最上面的一条横线 */

@property (nonatomic ,strong)UIButton *addBtn;/**< 添加按钮 */

@end

@implementation SMHomePageCollectionCell2

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];//KBlackColorLight;
        //KRedColorLight
        self.topView = [[UIView alloc] init];
        [self.contentView addSubview:self.topView];
        self.topView.backgroundColor = [UIColor whiteColor];
        self.topView.alpha = 0.2;
        
        self.addBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.addBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (isIPhone5) {
            dict[NSFontAttributeName] = KDefaultFont;
        }else{
            dict[NSFontAttributeName] = KDefaultFont;
        }
        
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"➕ 更多数据" attributes:dict];
        [self.addBtn setAttributedTitle:str forState:UIControlStateNormal];
        //[self.addBtn setImage:[UIImage imageNamed:@"addSmall"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark -- 点击事件
- (void)addBtnClick{
    if ([self.delegate respondsToSelector:@selector(addBtnDidClick)]) {
        [self.delegate addBtnDidClick];
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
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
}

@end
