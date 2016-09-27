//
//  SMAdvertisementScrollView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAdvertisementScrollView.h"

@interface SMAdvertisementScrollView ()<UIScrollViewDelegate>

@property (nonatomic ,strong)NSArray *arrAd;

/**
 *  滚动控件
 */
@property(nonatomic,strong) UIScrollView *scrollView;
/**
 *  定时器
 */
@property(nonatomic,strong) NSTimer *timer;
/**
 *  最后一个广告
 */
@property (nonatomic ,strong)UILabel *lastAd;
/**
 *  第一个广告
 */
@property (nonatomic ,strong)UILabel *firstAd;
/**
 *  模拟pageControl 中的页数变化
 */
@property (nonatomic ,assign)NSInteger currentPage;

@end

@implementation SMAdvertisementScrollView

//把需要轮播的文字装成一个数组 传进来
//+ (instancetype)advertisementWithArray:(NSArray *)arrAd{
//    
//    SMAdvertisementScrollView *view = [[SMAdvertisementScrollView alloc] init];
//    view.arrAd = arrAd;
//    return view;
//}

- (instancetype)initWithArray:(NSArray *)arrAd{
    if (self = [super init]) {
        
        self.arrAd = arrAd;
        //创建scrollView
        [self addSubview:self.scrollView];
        CGFloat w = CGRectGetWidth(self.scrollView.frame) - 60;
        CGFloat h = CGRectGetHeight(self.scrollView.frame);
        SMLog(@"self.arrAd.count  %zd",self.arrAd.count);
        //往scrollView中添加广告label
        for (int index = 0; index < self.arrAd.count; index++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = self.arrAd[index];
            label.font = KDefaultFont;
            label.tag = index;
            
            //设置frame
            CGFloat labelX = 0;
            CGFloat labelY = (index + 1) * h;
            label.frame = CGRectMake(labelX, labelY, w, h);
            label.numberOfLines = 0;
            
            //将广告添加到scrollView 上去
            [self.scrollView addSubview:label];
        }
        
        // 将最后一个广告放到第一个位置
        UILabel *lastAd = [[UILabel alloc] init];
        self.lastAd = lastAd;
        lastAd.frame = CGRectMake(0, 0, w, h);
        lastAd.text = self.arrAd.lastObject;
        lastAd.font = KDefaultFontBig;
        [self.scrollView addSubview:lastAd];
        lastAd.numberOfLines = 0;
        
        // 将第一个广告放到最后一个位置
        UILabel *firstAd = [[UILabel alloc] init];
        self.firstAd = firstAd;
        firstAd.frame = CGRectMake(0, (self.arrAd.count + 1) *h, w, h);
        firstAd.text = self.arrAd.firstObject;
        firstAd.font = KDefaultFontBig;
        [self.scrollView addSubview:firstAd];
        firstAd.numberOfLines = 0;
        
        
        // 设置滚动范围
        self.scrollView.contentSize = CGSizeMake(0, h * (self.arrAd.count + 2));
        // 隐藏水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        // 分页
        self.scrollView.pagingEnabled = YES;
        // 设置偏移量
        self.scrollView.contentOffset = CGPointMake(0, h);
        
        self.currentPage = 0;
        
        //开启定时器
        [self addTimer];
    }
    return self;
}

- (void)addTimer{
    //     timerWithTimeInterval:该方法创建的定时器对象默认没有被添加到运行循环。要手动添加
    self.timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(nextAd) userInfo:nil repeats:YES];
    // 只要将定时器对象添加到运行循环，就会自动开启定时器
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextAd{
    if (self.currentPage == self.arrAd.count) {
        self.currentPage = 0;
    }else{
        self.currentPage++;
    }
    // 获得scrollView高度
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    // 根据分页指示器当前的页码计算偏移量
    CGFloat offsetY = (self.currentPage + 1) * height; // 300
    // 设置偏移量
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

/**
 *  移除定时器
 */
- (void)removeTimer{
    // 让定时器失效：一旦定时器失效。则不能再使用，只能重新创建一个新的定时器
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UIScrollViewDelegate 代理方法
/**
 *  当用户开始拖拽时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止定时器
    [self removeTimer];
}

/**
 *  当scrollView正在拖拽的时候调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    YCLog(@"scrollViewDidScroll");
    // 获得scrollView宽度
    CGFloat height = CGRectGetHeight(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.y + height * 0.5) / height;
    //    YCLog(@"offset = %zd",page);
    // 设置pageControl要显示页码
    self.currentPage = --page;
    
}

/**
 * 减速完毕时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 获得scrollView宽度
    CGFloat height = CGRectGetHeight(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.y + height * 0.5) / height;
    if (page == self.arrAd.count + 1) { // 最后一张
        //        [scrollView setContentOffset:CGPointMake(width, 0)];
        [scrollView setContentOffset:CGPointMake(0, height) animated:NO]; // 不能使用动画
    } else if (page == 0) {
        [scrollView setContentOffset:CGPointMake(0,self.arrAd.count * height)];
    }
}


/**
 * 当用户停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

/**
 * 当滚动动画停止的时候调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark -- 懒加载
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        // 创建scrollView
        _scrollView = [[UIScrollView alloc] init];
         //设置frame
        CGFloat scrollX = [UIScreen mainScreen].bounds.size.width;
        CGFloat scrollY = 0;
        CGFloat scrollW = CGRectGetWidth(self.frame) - scrollX;
        CGFloat scrollH = 50 *SMMatchHeight;
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
//        _scrollView.frame = self.bounds;
        //设置背景颜色
        _scrollView.backgroundColor = [UIColor whiteColor];
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
