//
//  SMOrderManagerTopView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderManagerTopView.h"
#import "SMOrderManagerTopBtnView.h"

@interface SMOrderManagerTopView ()<UIScrollViewDelegate>



@property (nonatomic ,strong)UIPageControl *pageControl;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *allOrder;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *waitForPay;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *alreadyPay;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *alreadyDispatchGoods;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *returnGoods;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *alreadyDone;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *alreadyClosed;

@property (nonatomic ,strong)SMOrderManagerTopBtnView *refund; //退款

@property (nonatomic ,strong)NSMutableArray *arrViews;
@end

@implementation SMOrderManagerTopView

+ (instancetype)orderManagerTopView{
    return [[self alloc] init];
}

- (instancetype)init{
    if (self = [super init]) {

        [self addSubview:self.scrollView];
        
        //全部订单
        SMOrderManagerTopBtnView *allOrder = [[SMOrderManagerTopBtnView alloc] initWithStr:@"全部订单" image:[UIImage imageNamed:@"全部订单"]];
        [self.scrollView addSubview:allOrder];
        self.allOrder = allOrder;
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allOrderClick)];
        [allOrder addGestureRecognizer:tap0];
        [self.arrViews addObject:allOrder];
        [allOrder showRedName];
        
        //待付款
        SMOrderManagerTopBtnView *waitForPay = [[SMOrderManagerTopBtnView alloc] initWithStr:@"待付款" image:[UIImage imageNamed:@"待付款"]];
        [self.scrollView addSubview:waitForPay];
        self.waitForPay = waitForPay;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitForPayClick)];
        [waitForPay addGestureRecognizer:tap1];
        [self.arrViews addObject:waitForPay];
        
        //已付款
        SMOrderManagerTopBtnView *alreadyPay = [[SMOrderManagerTopBtnView alloc] initWithStr:@"已付款" image:[UIImage imageNamed:@"已付款"]];
        [self.scrollView addSubview:alreadyPay];
        self.alreadyPay = alreadyPay;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alreadyPayClick)];
        [alreadyPay addGestureRecognizer:tap2];
        [self.arrViews addObject:alreadyPay];
        
        //已发货
        SMOrderManagerTopBtnView *alreadyDispatchGoods = [[SMOrderManagerTopBtnView alloc] initWithStr:@"已发货" image:[UIImage imageNamed:@"已发货"]];
        [self.scrollView addSubview:alreadyDispatchGoods];
        self.alreadyDispatchGoods = alreadyDispatchGoods;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alreadyDispatchGoodsClick)];
        [alreadyDispatchGoods addGestureRecognizer:tap3];
        [self.arrViews addObject:alreadyDispatchGoods];
        
        //已完成
        SMOrderManagerTopBtnView *alreadyDone = [[SMOrderManagerTopBtnView alloc] initWithStr:@"已完成" image:[UIImage imageNamed:@"已完成"]];
        [self.scrollView addSubview:alreadyDone];
        self.alreadyDone = alreadyDone;
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alreadyDoneClick)];
        [alreadyDone addGestureRecognizer:tap4];
        [self.arrViews addObject:alreadyDone];
        
        //已关闭
        SMOrderManagerTopBtnView *alreadyClosed = [[SMOrderManagerTopBtnView alloc] initWithStr:@"已关闭" image:[UIImage imageNamed:@"已关闭"]];
        [self.scrollView addSubview:alreadyClosed];
        self.alreadyClosed = alreadyClosed;
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alreadyClosedClick)];
        [alreadyClosed addGestureRecognizer:tap5];
        [self.arrViews addObject:alreadyClosed];
        
        //退款,已退款
        SMOrderManagerTopBtnView *refund = [[SMOrderManagerTopBtnView alloc] initWithStr:@"退款/售后" image:[UIImage imageNamed:@"退换货icon"]];
        [self.scrollView addSubview:refund];
        self.refund = refund;
        UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refundClick)];
        [refund addGestureRecognizer:tap6];
        [self.arrViews addObject:refund];
        
        [self addSubview:self.pageControl];

    }
    return self;
}

#pragma mark -- 点击事件

- (void)refundClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.refund showRedName];
    if ([self.delegate respondsToSelector:@selector(refundDidClick)]) {
        [self.delegate refundDidClick];
    }
}

- (void)alreadyClosedClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.alreadyClosed showRedName];
    if ([self.delegate respondsToSelector:@selector(alreadyClosedDidClick)]) {
        [self.delegate alreadyClosedDidClick];
    }
}

- (void)alreadyDoneClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.alreadyDone showRedName];
    if ([self.delegate respondsToSelector:@selector(alreadyDoneDidClick)]) {
        [self.delegate alreadyDoneDidClick];
    }
}

- (void)alreadyDispatchGoodsClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.alreadyDispatchGoods showRedName];
    if ([self.delegate respondsToSelector:@selector(alreadyDispatchGoodsDidClick)]) {
        [self.delegate alreadyDispatchGoodsDidClick];
    }
}

- (void)alreadyPayClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.alreadyPay showRedName];
    if ([self.delegate respondsToSelector:@selector(alreadyPayDidClick)]) {
        [self.delegate alreadyPayDidClick];
    }
}

- (void)waitForPayClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.waitForPay showRedName];
    if ([self.delegate respondsToSelector:@selector(waitForPayDidClick)]) {
        [self.delegate waitForPayDidClick];
    }
}

- (void)allOrderClick{
    for (SMOrderManagerTopBtnView *view in self.arrViews) {
        [view showBlackName];
    }
    [self.allOrder showRedName];
    if ([self.delegate respondsToSelector:@selector(allOrderDidClick)]) {
        [self.delegate allOrderDidClick];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;

    
    CGFloat pageControlW = 80;
    CGFloat pageControlH = 10;
    CGFloat pageControlX = (self.width - pageControlW) * 0.5;
    CGFloat pageControlY = self.height - pageControlH;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    CGFloat margin = 10;
    CGFloat w = (KScreenWidth - 2 *margin) / 5.0;
//    NSNumber *width = [NSNumber numberWithFloat:w];
//    CGFloat marginBottom = -25;
    
    self.allOrder.frame = CGRectMake(10, 0, w *SMMatchWidth, self.height - 25);
    self.waitForPay.frame = CGRectMake(10 + w *1, 0, w *SMMatchWidth, self.height - 25);
    self.alreadyPay.frame = CGRectMake(10 + w *2, 0, w *SMMatchWidth, self.height - 25);
    self.alreadyDispatchGoods.frame = CGRectMake(10 + w *3, 0, w *SMMatchWidth, self.height - 25);
    self.alreadyDone.frame = CGRectMake(10 + w *4, 0, w *SMMatchWidth, self.height - 25);
    self.alreadyClosed.frame = CGRectMake(10 + w *5, 0, w *SMMatchWidth, self.height - 25);
    self.refund.frame = CGRectMake(10 + w *6, 0, w *SMMatchWidth, self.height - 25);
}

- (void)pageControlValueChanged{
    SMLog(@"pageControlValueChanged   self.pageControl.currentPage   %zd",self.pageControl.currentPage);
    if (self.pageControl.currentPage == 0) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else if (self.pageControl.currentPage == 1){
        self.scrollView.contentOffset = CGPointMake(KScreenWidth, 0);
    }
}

#pragma mark -- UIScrollViewDelegate
/**
 *  当scrollView正在拖拽的时候调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    YCLog(@"scrollViewDidScroll");
    // 获得scrollView宽度
    CGFloat width = CGRectGetWidth(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width;
    //    YCLog(@"offset = %zd",page);
    // 设置pageControl要显示页码
    self.pageControl.currentPage = page;
    SMLog(@"page   %zd",page);
}


#pragma mark -- 懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(KScreenWidth *2, 80 *SMMatchHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        // 创建分页指示器
        _pageControl = [[UIPageControl alloc] init];
        // 设置点颜色(未选中点的颜色)
        _pageControl.pageIndicatorTintColor = SMColor(96, 95, 95);
        // 设置当前点的颜色
        _pageControl.currentPageIndicatorTintColor = KRedColorLight;
        // 设置总页数
        _pageControl.numberOfPages = 2;
        // 设置frame
        
        [_pageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];
        
        //        _pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    }
    return _pageControl;
}

- (NSMutableArray *)arrViews{
    if (_arrViews == nil) {
        _arrViews = [NSMutableArray array];
    }
    return _arrViews;
}


@end
