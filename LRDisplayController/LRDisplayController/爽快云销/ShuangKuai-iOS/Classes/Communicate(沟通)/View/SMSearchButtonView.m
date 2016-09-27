//
//  SMSearchButtonView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchButtonView.h"

@interface SMSearchButtonView ()
@property (nonatomic,strong) UIButton *searchButton;/**< 搜索按钮 */
@end

@implementation SMSearchButtonView

-(UIButton *)searchButton{
    if (_searchButton == nil) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.titleLabel.font = KDefaultFont;
        _searchButton.layer.cornerRadius = SMCornerRadios;
        _searchButton.layer.masksToBounds = YES;
        [_searchButton setImage:[UIImage imageNamed:@"fangdajing2"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _searchButton.backgroundColor = [UIColor whiteColor];
        [_searchButton addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchButton];
    }
    return _searchButton;
}

-(void)searchBtnClick{
    if ([self.delegate respondsToSelector:@selector(searchButtonClick)]) {
        [self.delegate searchButtonClick];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.searchButton.frame = CGRectMake(10, 8, self.frame.size.width - 10*2, self.frame.size.height - 8*2);
}

@end
