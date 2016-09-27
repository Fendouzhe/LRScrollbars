//
//  SMCareVcBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCareVcBottomView.h"
#import "SMHotProductController.h"
#import "SMHotActionController.h"
#import "SMNewsController.h"

@interface SMCareVcBottomView ()

@property (nonatomic ,strong)UIView *topView;
/**
 *  热销产品
 */
@property (nonatomic ,strong)UIButton *hotProducts;
/**
 *  劲爆活动
 */
@property (nonatomic ,strong)UIButton *hotActions;
/**
 *  最新动态
 */
@property (nonatomic ,strong)UIButton *news;
/**
 *  最下面的灰色横线
 */
@property (nonatomic ,strong)UIView *bottomGrayLine;

@property (nonatomic ,strong)UIView *redViewLeft;

@property (nonatomic ,strong)UIView *redViewMid;

@property (nonatomic ,strong)UIView *redViewRight;

/**
 *  下面展示图片的整体
 */
@property (nonatomic ,strong)UIView *bottomView;

@end

@implementation SMCareVcBottomView

+ (instancetype)careVcBottomView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //把 上面一排可以点击的按钮（热销产品）这些 作为一个整体topView
        [self setupTopView];
        
        //把下面的几个战士图片的部分作为是一个整体 bottomView
        [self setupBottomView];
    }
    return self;
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

- (void)setupTopView{
    //上半部view
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    self.topView = topView;
    
    //热销产品
    UIButton *hotProducts = [self buttonWithTitle:@"热销产品" font:[UIFont systemFontOfSize:15]];
    [self addSubview:hotProducts];
    self.hotProducts = hotProducts;
    [hotProducts addTarget:self action:@selector(hotProductsClick:) forControlEvents:UIControlEventTouchUpInside];
    hotProducts.selected = YES;
    
    //劲爆活动
    UIButton *hotActions = [self buttonWithTitle:@"劲爆活动" font:[UIFont systemFontOfSize:15]];
    [self addSubview:hotActions];
    self.hotActions = hotActions;
    [hotActions addTarget:self action:@selector(hotActionsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //最新动态
    UIButton *news = [self buttonWithTitle:@"最新动态" font:[UIFont systemFontOfSize:15]];
    [self addSubview:news];
    self.news = news;
    [news addTarget:self action:@selector(newsClick:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)setupBottomView{
    //下面的整体view
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    //vc1 的view 添加进来
    SMHotProductController *vc1 = [[SMHotProductController alloc] init];
    self.vc1 = vc1;
    [bottomView addSubview:vc1.view];
    
    SMHotActionController *vc2 = [[SMHotActionController alloc] init];
    self.vc2 = vc2;
    [bottomView addSubview:vc2.view];
    vc2.view.hidden = YES;
    
    SMNewsController *vc3 = [[SMNewsController alloc] init];
    self.vc3 = vc3;
    [bottomView addSubview:vc3.view];
    vc3.view.hidden = YES;
}

#pragma mark -- 点击事件
- (void)hotProductsClick:(UIButton *)btn{
    [self topBtnClick:btn];
}

- (void)hotActionsClick:(UIButton *)btn{
    [self topBtnClick:btn];
}

- (void)newsClick:(UIButton *)btn{
    [self topBtnClick:btn];
}

- (void)topBtnClick:(UIButton *)btn{
    self.hotProducts.selected = NO;
    self.hotActions.selected = NO;
    self.news.selected = NO;
    btn.selected = YES;
    
    self.redViewLeft.hidden = !self.hotProducts.selected;
    self.redViewMid.hidden = !self.hotActions.selected;
    self.redViewRight.hidden = !self.news.selected;
    
    self.vc1.view.hidden = !self.hotProducts.selected;
    self.vc2.view.hidden = !self.hotActions.selected;
    self.vc3.view.hidden = !self.news.selected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //上半部分
    CGFloat topViewH;
    if (isIPhone5) {
        topViewH = 40;
    }else if (isIPhone6){
        topViewH = 40 *KMatch6;
    }else if (isIPhone6p){
        topViewH = 40 *KMatch6p;
    }
    self.topView.frame = CGRectMake(0, 0, KScreenWidth, topViewH);
    
    //左边红线
    CGFloat margin = 15;
    CGFloat lineW = (KScreenWidth - margin * 4) / 3.0;
    CGFloat lineH = 1;
    self.redViewLeft.frame = CGRectMake(margin, topViewH - lineH, lineW, lineH);
    
    //中间红线
    self.redViewMid.frame = CGRectMake(margin *2 + lineW, topViewH - lineH, lineW, lineH);
    
    //右边红线
    self.redViewRight.frame = CGRectMake(margin *3 + lineW *2, topViewH - lineH, lineW, lineH);
    
    //热销产品
    self.hotProducts.frame = CGRectMake(margin, 0, lineW, topViewH - lineH);
    
    //劲爆活动
    self.hotActions.frame = CGRectMake(margin *2 + lineW, 0, lineW, topViewH - lineH);
    
    //最新动态
    self.news.frame = CGRectMake(margin *3 + lineW *2, 0, lineW, topViewH - lineH);
    
    //最下面的灰线
    self.bottomGrayLine.frame = CGRectMake(0, topViewH, KScreenWidth, lineH);
    
//    self.topView.backgroundColor = [UIColor yellowColor];
//    self.bottomView.backgroundColor = [UIColor redColor];
    
    //下半部分 展示图片的view
    self.bottomView.frame = CGRectMake(0, topViewH, KScreenWidth, KScreenHeight - topViewH);
    
    self.vc1.view.frame = self.bottomView.bounds;
    
    self.vc2.view.frame = self.bottomView.bounds;
    
    self.vc3.view.frame = self.bottomView.bounds;
}

@end
