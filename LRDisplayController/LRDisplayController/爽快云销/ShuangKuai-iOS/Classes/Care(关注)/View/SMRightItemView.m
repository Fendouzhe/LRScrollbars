//
//  SMRightItemView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMRightItemView.h"
#import "SMScanerBtn.h"

@interface SMRightItemView ()

@property (nonatomic ,strong)SMScanerBtn *scanerBtn;

@property (nonatomic ,strong)UIButton *searchBtn;

@end

@implementation SMRightItemView

+ (instancetype)rightItemView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加控件
        UIButton *searchBtn = [[UIButton alloc] init];
        [self addSubview:searchBtn];
        self.searchBtn = searchBtn;
      
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];

        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
        [self addSubview:scanerBtn];
        self.scanerBtn = scanerBtn;
        [scanerBtn addTarget:self action:@selector(scanerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setIsCreatedByShoppingVC:(BOOL)isCreatedByShoppingVC{
    _isCreatedByShoppingVC = isCreatedByShoppingVC;
    [self.scanerBtn setBackgroundImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    self.scanerBtn.isCreatedByShoppingVC = isCreatedByShoppingVC;
}

-(void)setIsCreatedByCareVC:(BOOL)isCreatedByCareVC{
    _isCreatedByCareVC = isCreatedByCareVC;
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"fangdajingWhite"] forState:UIControlStateNormal];
    self.scanerBtn.isCreatedByCareVC = isCreatedByCareVC;
    
    
}
- (void)searchBtnClick{
    if ([self.delegate respondsToSelector:@selector(searchBtnDidClick)]) {
        [self.delegate searchBtnDidClick];
    }
}

- (void)scanerBtnClick{
    if ([self.delegate respondsToSelector:@selector(scanerBtnDidClick)]) {
        [self.delegate scanerBtnDidClick];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //搜索按钮
    CGFloat searchH = self.bounds.size.height;
    CGFloat searchW = searchH;
    self.searchBtn.frame = CGRectMake(10, 0, searchW, searchH);
    
    //二维码按钮
    CGFloat margin = 30;
    CGFloat scanerX = searchW + margin;
    self.scanerBtn.frame = CGRectMake(scanerX+10, 0, searchW, searchH);
}

@end
