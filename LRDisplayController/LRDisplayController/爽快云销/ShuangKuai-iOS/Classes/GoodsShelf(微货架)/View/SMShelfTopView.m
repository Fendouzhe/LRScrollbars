//
//  SMShelfTopView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/12.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfTopView.h"

/**
 *  “我的微货架”  这几个文字的颜色
 */
#define KShelfTitleColor SMColor(188, 0, 19)

typedef enum : NSUInteger {
    ShelfTopBtnTypeMyShel,
    ShelfTopBtnTypeMyPopularize,
    ShelfTopBtnTypeShoppingCar,
    ShelfTopBtnTypeShare,
} ShelfTopBtnType;

@interface SMShelfTopView ()

/**
 *  我的微货架下面的横线
 */
@property (nonatomic ,strong)UILabel *shelfUnderLabel;

/**
 *  我的微推广 下面的横线
 */
@property (nonatomic ,strong)UILabel *popularizeUnderLabel;

/**
 *  购物车按钮
 */
@property (nonatomic ,strong)UIButton *shoppingCar;

/**
 *  分享按钮
 */
@property (nonatomic ,strong)UIButton *shareBtn;

@end

@implementation SMShelfTopView

+ (instancetype)shelfTopView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KControllerBackGroundColor;
        
        /**
         我的微货架Btn
         */
        UIButton *myShelfBtn = [[UIButton alloc] init];
        self.myShelfBtn = myShelfBtn;
        [self addSubview:myShelfBtn];
        myShelfBtn.selected = YES;
        myShelfBtn.tag = ShelfTopBtnTypeMyShel;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"我的微货架" attributes:dict];
        [myShelfBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        dict2[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        dict2[NSForegroundColorAttributeName] = KShelfTitleColor;
        NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"我的微货架" attributes:dict2];
        [myShelfBtn setAttributedTitle:attributeStr2 forState:UIControlStateSelected];
        [myShelfBtn addTarget:self action:@selector(shelfBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  我的微货架下面的横线
         */
        UILabel *shelfUnderLabel = [[UILabel alloc] init];
        self.shelfUnderLabel = shelfUnderLabel;
        [self addSubview:shelfUnderLabel];
        shelfUnderLabel.backgroundColor = KShelfTitleColor;
        
        /**
         *  我的微推广
         */
        UIButton *myPopularizeBtn = [[UIButton alloc] init];
        self.myPopularizeBtn = myPopularizeBtn;
        [self addSubview:myPopularizeBtn];
        myPopularizeBtn.tag = ShelfTopBtnTypeMyPopularize;
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        dict3[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        dict3[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:@"我的微推广" attributes:dict3];
        [myPopularizeBtn setAttributedTitle:attributeStr3 forState:UIControlStateNormal];
    
        NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
        dict4[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        dict4[NSForegroundColorAttributeName] = KShelfTitleColor;
        NSAttributedString *attributeStr4 = [[NSAttributedString alloc] initWithString:@"我的微推广" attributes:dict4];
        [myPopularizeBtn setAttributedTitle:attributeStr4 forState:UIControlStateSelected];
        [myPopularizeBtn addTarget:self action:@selector(popularizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  我的微推广 下面的横线
         */
        UILabel *popularizeUnderLabel = [[UILabel alloc] init];
        self.popularizeUnderLabel = popularizeUnderLabel;
        [self addSubview:popularizeUnderLabel];
        popularizeUnderLabel.backgroundColor = KShelfTitleColor;
        popularizeUnderLabel.hidden = YES;
        
        /**
         *  购物车按钮
         */
        UIButton *shoppingCar = [[UIButton alloc] init];
        shoppingCar.tag =ShelfTopBtnTypeShoppingCar;
        self.shoppingCar = shoppingCar;
        [self addSubview:shoppingCar];
        [shoppingCar setBackgroundImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        [shoppingCar addTarget:self action:@selector(shoppingCarDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  分享按钮
         */
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.tag = ShelfTopBtnTypeShare;
        self.shareBtn = shareBtn;
        [self addSubview:shareBtn];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark -- 按钮点击事件 
- (void)shoppingCarDidClick:(UIButton *)btn{
    SMLog(@"点击了购物车按钮");
    [self deleteMethodWithButton:btn];
}

- (void)shareBtnDidClick:(UIButton *)btn{
    SMLog(@"点击了 分享按钮");
    [self deleteMethodWithButton:btn];
}

- (void)shelfBtnClick:(UIButton *)btn{
    
    if (self.myShelfBtn.selected) {
        return;
    }
    SMLog(@"点击了 我的微货架 按钮");
    self.myPopularizeBtn.selected = NO;
    btn.selected = !btn.selected;
    self.shelfUnderLabel.hidden = !self.myShelfBtn.selected;
    self.popularizeUnderLabel.hidden = !self.myPopularizeBtn.selected;
    [self deleteMethodWithButton:btn];
}

- (void)popularizeBtnClick:(UIButton *)btn{
    
    if (self.myPopularizeBtn.selected) {
        return;
    }
    SMLog(@"点击了 我的微推广 按钮");
    self.myShelfBtn.selected = NO;
    btn.selected = !btn.selected;
    self.shelfUnderLabel.hidden = !self.myShelfBtn.selected;
    self.popularizeUnderLabel.hidden = !self.myPopularizeBtn.selected;
    [self deleteMethodWithButton:btn];
}

- (void)deleteMethodWithButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(shelfTopViewDidClick:)]) {
        [self.delegate shelfTopViewDidClick:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //从右往左约束的
    CGFloat marginLeftRight = 15;
    //几个按钮之间的间距
    CGFloat margin = (KScreenWidth - 76 - 76 - 22 - 22 - marginLeftRight * 2) / 3.0;
    
    //分享键
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-marginLeftRight);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    //购物车
    [self.shoppingCar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.shareBtn.mas_left).with.offset(-margin);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    //我的微推广
    [self.myPopularizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.shoppingCar.mas_left).with.offset(-margin);
        make.width.equalTo(@76);
        make.height.equalTo(@16);
    }];
    
    //我的微货架
    [self.myShelfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.myPopularizeBtn.mas_left).with.offset(-margin);
        make.width.equalTo(@76);
        make.height.equalTo(@16);
    }];
    
    //我的微货架 下面的横线
    [self.shelfUnderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.left.equalTo(self.mas_left).with.offset(marginLeftRight);
        make.width.equalTo(@76);
        make.height.equalTo(@1);
    }];
    
    //我的微推广 下面的横线
    [self.popularizeUnderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.left.equalTo(self.shelfUnderLabel.mas_right).with.offset(margin);
        make.width.equalTo(@76);
        make.height.equalTo(@1);
    }];
    
}

@end
