//
//  SMNewRigthItemVIew.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewRigthItemVIew.h"


@interface SMNewRigthItemVIew ()


@property (nonatomic ,strong)UIButton *searchBtn;

@property(nonatomic ,strong)UIButton * btn;

@end

@implementation SMNewRigthItemVIew


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

+ (instancetype)initWithBarButtonItemsImage:(NSString *)rigthImageName andleftImage:(NSString *)leftImageName
{
    SMNewRigthItemVIew * view = [SMNewRigthItemVIew new];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [view addSubview:searchBtn];
    view.searchBtn = searchBtn;
    [searchBtn setBackgroundImage:[UIImage imageNamed:rigthImageName] forState:UIControlStateNormal];
    [searchBtn addTarget:view action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [[UIButton alloc] init];
    [view addSubview:btn];
    view.btn = btn;
    [btn setBackgroundImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    [btn addTarget:view action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)searchClick{
    if ([self.delegate respondsToSelector:@selector(searchBtnDidClick)]) {
        [self.delegate searchBtnDidClick];
    }
}

- (void)BtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(BtnDidClick:)]) {
        [self.delegate BtnDidClick:btn];
        SMLog(@"right = %p",btn);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //搜索按钮
    CGFloat searchH = self.bounds.size.height;
    CGFloat searchW = searchH;
    self.searchBtn.frame = CGRectMake(10, 0, searchW, searchH);
    
    //
    if (self.isNameString) {
        CGFloat margin = 25;
        CGFloat scanerX = searchW + margin;
        self.btn.frame = CGRectMake(scanerX + 15, 0, searchW+8, searchH);
    }else
    {
        CGFloat margin = 30;
        CGFloat scanerX = searchW + margin;
        self.btn.frame = CGRectMake(scanerX, 0, searchW, searchH);
    }
    
}

+ (instancetype)initWithBarButtonItemsName:(NSString *)rigthName andleftImage:(NSString *)leftImageName
{
    SMNewRigthItemVIew * view = [SMNewRigthItemVIew new];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [view addSubview:searchBtn];
    view.searchBtn = searchBtn;
    [searchBtn setBackgroundImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    [searchBtn addTarget:view action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [[UIButton alloc] init];
    [view addSubview:btn];
    [btn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    view.btn = btn;
    [btn setTitle:rigthName forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 *SMMatchWidth];
    [btn addTarget:view action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    view.isNameString = YES;
    return view;
}
@end
