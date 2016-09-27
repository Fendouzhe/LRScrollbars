//
//  SMScenePromotionController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScenePromotionController.h"
#import "SMLeftItemBtn.h"
#import "SMScanerBtn.h"
#import "SMPersonInfoViewController.h"
#import "SMScannerViewController.h"
#import "SMCustomScrollview.h"
#import <UIImageView+WebCache.h>


@interface SMScenePromotionController ()<UIScrollViewDelegate>

@property (nonatomic ,strong)SMLeftItemBtn *leftItemBtn;/**< 左上角头像 */

/**
 * 给Scrollview添加点击手势
 **/
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/**
 * 定义属性
 **/
@property (nonatomic, strong) SMCustomScrollview *scrollView;

///**
// * 图片网址数组
// **/
//@property (nonatomic, strong) NSArray *urlArray;

@property (nonatomic ,strong)NSArray *localArr;/**< 图片本地数组 */

/**
 * 定义pageControl
 **/
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation SMScenePromotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.scrollView = [[SMCustomScrollview alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - 34) target:self];
    /********* 修改了它的高度，只要是为了看清楚动画偏移原因 **********/
    [self.view addSubview:_scrollView];
    self.localArr = @[@"scenePromotion5",@"scenePromotion0",@"scenePromotion1",@"scenePromotion2",@"scenePromotion3",@"scenePromotion4",@"scenePromotion5",@"scenePromotion0"];
    
    [_scrollView loadImages:self.localArr];
    
    /********* 添加了这一行代码 **********/
    _scrollView.scrollview.contentOffset = CGPointMake(KScreenWidth * 2 / 3, 0);
    /********* 添加了这一行代码 **********/
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_scrollView addGestureRecognizer:_tap];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64 - 20 *SMMatchHeight, KScreenWidth, 30)];
    [self.view addSubview:_pageControl];
    
    // 真实的图片是 0 －－ 5，共6张，数组里实际是8张
    _pageControl.numberOfPages = self.localArr.count - 2;
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.currentPageIndicatorTintColor = KRedColorLight;
    /********* 修改了这一行代码 **********/
    _pageControl.currentPage = 5;
    
    
    
}

/**
 * 当滚动动画停止的时候调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

// scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
#warning 修改了这里
//    NSInteger currentIndex = scrollView.contentOffset.x / (KScreenWidth * 2 / 3)-1;
//    
//    if(currentIndex > 5){
//        _pageControl.currentPage = 0;
//    }else if (currentIndex < 0){
//        _pageControl.currentPage = 5;
//    }else{
//        _pageControl.currentPage = currentIndex;
//    }
    
    // 获得scrollView宽度
    CGFloat width = CGRectGetWidth(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width;
    
    SMLog(@"page scrollViewDidEndDecelerating  %zd",page);
    _pageControl.currentPage = page - 2;
    if (page - 2 == -1) {
        _pageControl.currentPage = 5;
    }else if (page - 2 == -2){
        _pageControl.currentPage = 4;
    }
    if (page == self.localArr.count - 1) { // 最后一张
#warning 修改了y方向上的偏移量之后就好了，具体原因不清楚，也不知道为什么是－64,一个导航条的高度，设置其他的高度都不行
        /********* 修改了y方向上的偏移量之后就好了 **********/
        scrollView.contentOffset = CGPointMake(width, 0);
        /********* 修改了y方向上的偏移量之后就好了 **********/
        
    } else if (page == 0) {
        
        /********* 修改了y方向上的偏移量之后就好了 **********/
        [scrollView setContentOffset:CGPointMake((self.localArr.count - 2) * width, 0) animated:NO ];
        /********* 修改了y方向上的偏移量之后就好了 **********/
    }
}

// scrollView 的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_scrollView scroll];
}

# warning 跳转这里要修改一下, 要给它真实的图片数组
// 点击事件
- (void)tap:(UITapGestureRecognizer *)tap{
    
    SMLog(@"点击了 轮播图片  %zd", _pageControl.currentPage);
    

}



- (void)setupNav{

    self.title = @"场景推广";
    self.view.backgroundColor = KControllerBackGroundColor;
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftItemBtn = leftItemBtn;
    CGFloat wh;
    if (isIPhone5) {
        wh = KIconWH;
    }else if (isIPhone6){
        wh = KIconWH *KMatch6;
    }else if (isIPhone6p){
        wh = KIconWH * KMatch6p;
    }
    
    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //二维码
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.leftItemBtn.customImageView.image = image;
    }
    
}

- (void)leftItemDidClick:(UIButton *)leftBtn{
    SMLog(@"点击了左上角的头像按钮  %@",[leftBtn class]);
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanerBtnDidClick{
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

@end
