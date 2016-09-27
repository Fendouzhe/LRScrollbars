//
//  SMDiscoverBottomHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscoverBottomHeaderView.h"

@interface SMDiscoverBottomHeaderView ()

@property (nonatomic ,strong)UIButton *hotProducts;

@property (nonatomic ,strong)UIButton *hotActions;



@property (nonatomic ,strong)UIView *bottomGrayLine;

@property (nonatomic ,strong)UIView *redViewLeft;

@property (nonatomic ,strong)UIView *redViewMid;

@property (nonatomic ,strong)UIView *redViewRight;

@property (nonatomic ,strong)UIView *bottomView;

@end

@implementation SMDiscoverBottomHeaderView

+ (instancetype)discoverBottomHeaderView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        //热销产品
        UIButton *hotProducts = [self buttonWithTitle:@"热销商品" font:[UIFont systemFontOfSize:15]];
        [self addSubview:hotProducts];
        self.hotProducts = hotProducts;
        [hotProducts addTarget:self action:@selector(hotProductsClick:) forControlEvents:UIControlEventTouchUpInside];
        hotProducts.selected = YES;
        hotProducts.tag = 0;
        
        //劲爆活动
//        UIButton *hotActions = [self buttonWithTitle:@"劲爆活动" font:[UIFont systemFontOfSize:15]];
//        [self addSubview:hotActions];
//        self.hotActions = hotActions;
//        [hotActions addTarget:self action:@selector(hotActionsClick:) forControlEvents:UIControlEventTouchUpInside];
//        hotActions.tag = 1;
        
        //最新动态
        UIButton *news = [self buttonWithTitle:@"最新动态" font:[UIFont systemFontOfSize:15]];
        [self addSubview:news];
        self.news = news;
        [news addTarget:self action:@selector(newsClick:) forControlEvents:UIControlEventTouchUpInside];
        news.tag = 2;
        
        //最下面的灰色横线
        UIView *bottomGrayLine = [[UIView alloc] init];
        [self addSubview:bottomGrayLine];
        bottomGrayLine.backgroundColor = [UIColor lightGrayColor];
        self.bottomGrayLine = bottomGrayLine;
        
        //左边红线
        UIView *redViewLeft = [[UIView alloc] init];
        [self addSubview:redViewLeft];
        self.redViewLeft = redViewLeft;
        redViewLeft.backgroundColor = KRedColor;
        
        //中间红线
        UIView *redViewMid = [[UIView alloc] init];
        [self addSubview:redViewMid];
        self.redViewMid = redViewMid;
        redViewMid.backgroundColor = KRedColor;
        redViewMid.hidden = YES;
        
        //右边红线
        UIView *redViewRight = [[UIView alloc] init];
        [self addSubview:redViewRight];
        self.redViewRight = redViewRight;
        redViewRight.backgroundColor = KRedColor;
        redViewRight.hidden = YES;

        
    }
    return self;
}

- (void)hotProductsClick:(UIButton *)btn{
    [self postNotificationWithBtn:btn];
}

- (void)hotActionsClick:(UIButton *)btn{
    [self postNotificationWithBtn:btn];
}

- (void)newsClick:(UIButton *)btn{
    [self postNotificationWithBtn:btn];
}

- (void)postNotificationWithBtn:(UIButton *)btn{
    //发布通知
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KDisCoverNoteClickWithBtnKey] = btn;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KDisCoverNoteClickWithBtn object:self userInfo:dict];
    
    //改变各个按钮状态
    self.hotProducts.selected = NO;
    self.hotActions.selected = NO;
    self.news.selected = NO;
    btn.selected = YES;
    
    self.redViewLeft.hidden = !self.hotProducts.selected;
    self.redViewMid.hidden = !self.hotActions.selected;
    self.redViewRight.hidden = !self.news.selected;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat topViewH;
    if (isIPhone5) {
        topViewH = 40;
    }else if (isIPhone6){
        topViewH = 40 *KMatch6;
    }else if (isIPhone6p){
        topViewH = 40 *KMatch6p;
    }
    
    //左边红线
    CGFloat margin = 15;
    CGFloat lineW = (KScreenWidth - margin * 4) / 2.0;
    CGFloat lineH = 1;
    self.redViewLeft.frame = CGRectMake(margin, topViewH - lineH, lineW, lineH);
    
    //中间红线
    self.redViewRight.frame = CGRectMake(margin *2 + lineW, topViewH - lineH, lineW, lineH);
    
    //右边红线
    //self.redViewRight.frame = CGRectMake(margin *3 + lineW *2, topViewH - lineH, lineW, lineH);
    
    //热销产品
    self.hotProducts.frame = CGRectMake(margin, 0, lineW, topViewH - lineH);
    
    //劲爆活动
    self.news.frame = CGRectMake(margin *2 + lineW, 0, lineW, topViewH - lineH);
    
    //最新动态
    //self.news.frame = CGRectMake(margin *3 + lineW *2, 0, lineW, topViewH - lineH);
    
    //最下面的灰线
    self.bottomGrayLine.frame = CGRectMake(0, topViewH, KScreenWidth, lineH);
    
    //    self.topView.backgroundColor = [UIColor yellowColor];
    //    self.bottomView.backgroundColor = [UIColor redColor];
    
    //下半部分 展示图片的view
    self.bottomView.frame = CGRectMake(0, topViewH, KScreenWidth, KScreenHeight - topViewH);
}

- (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font{
    
    UIButton *btn = [[UIButton alloc] init];
    NSMutableDictionary *dictN = [NSMutableDictionary dictionary];
    dictN[NSFontAttributeName] = font;
    dictN[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *strNormal = [[NSAttributedString alloc] initWithString:title attributes:dictN];
    [btn setAttributedTitle:strNormal forState:UIControlStateNormal];
    
    NSMutableDictionary *dictS = [NSMutableDictionary dictionary];
    dictS[NSFontAttributeName] = font;
    dictS[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *strSelected = [[NSAttributedString alloc] initWithString:title attributes:dictS];
    [btn setAttributedTitle:strSelected forState:UIControlStateSelected];
    
    return btn;
}

@end
