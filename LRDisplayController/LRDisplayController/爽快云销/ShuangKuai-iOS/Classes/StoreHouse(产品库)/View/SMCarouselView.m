//
//  SMCarouselView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCarouselView.h"

/**
 *  图片的总数量
 */
//#define SMImageCount 3

@interface SMCarouselView ()<UIScrollViewDelegate>

/**
 *  滚动控件
 */
@property(nonatomic,strong) UIScrollView *scrollView;
/**
 *  分页指示器
 */
@property(nonatomic,strong) UIPageControl *pageControl;
/**
 *  定时器
 */
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic ,assign)NSInteger currentSelectedPage;
/**
 *  轮播器内的imageViews 数组
 */
@property (nonatomic ,strong)NSMutableArray *arrImageViews;
/**
 *  存放轮播器需要的image
 */
@property (nonatomic ,strong)NSArray *arrImages;

@property (nonatomic ,strong)UIImageView *lastImageView;

@property (nonatomic ,strong)UIImageView *firstImageView;

@end

@implementation SMCarouselView



//#pragma mark -- 模型赋值
//- (void)setProduct:(Product *)product{
//    _product = product;
//    NSArray *arrImages = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
//    self.arrImages = arrImages;
//    
//    NSInteger count = self.arrImages.count;
//    for (int i = 0; i < count; i++) {
//        NSURL *url = [NSURL URLWithString:self.arrImages[i]];
//        [self.arrImageViews[i] sd_setImageWithURL:url];
//    }
//    NSURL *lastUrl = [NSURL URLWithString:self.arrImages.lastObject];
//    [self.lastImageView sd_setImageWithURL:lastUrl];
//    
//    NSURL *firstUrl = [NSURL URLWithString:self.arrImages.firstObject];
//    [self.firstImageView sd_setImageWithURL:firstUrl];
//}

/**
 *  监听分页指示器值的改变
 */
- (void)pageControlValueChanged{
    //YCLog(@"pageControlValueChanged");
}

//- (instancetype)init{
//    if(self = [super init])
//    {
//        // 添加scrollView
//        [self addSubview:self.scrollView];
//        
//        // 设置图片的宽高
//        CGFloat imageW = CGRectGetWidth(self.scrollView.frame);
//        CGFloat imageH = CGRectGetHeight(self.scrollView.frame);
//        // 往scorllView添加3张图片
//        for (int index = 0; index < SMImageCount ; index++) {
//#warning Bmob 这里设置图片
//            // 获得图片的名字
////            NSString *imageName = [NSString stringWithFormat:@"yifu0%d",index];
////            NSString *imageName = @"yifu02";
//            // 创建UIImageView
//            UIImageView *imageView = [[UIImageView alloc] init];
//            [self.arrImageViews addObject:imageView];
//            // 设置图片
////            imageView.image = [UIImage imageNamed:imageName];
//            imageView.userInteractionEnabled = YES;
//            
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClicked)];
//            [self addGestureRecognizer:tap];
//            
//            //获取Bmob服务器上的数据
//            
//            
//            // 设置frame
//            CGFloat imageX = (index + 1) * imageW ; // 0 1 2
//            CGFloat imageY = 0;
//            
//            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//            
//            // 将图片添加到scrollView上面
//            [self.scrollView addSubview:imageView];
//        }
//        
//        // 将最后一张图片放到第一个位置
//        UIImageView *lastImageView = [[UIImageView alloc] init];
//        lastImageView.frame = CGRectMake(0, 0, imageW, imageH);
//        // 设置图片
////        lastImageView.image = [UIImage imageNamed:@"yifu02"];
//        self.lastImageView = lastImageView;
//        [self.scrollView addSubview:lastImageView];
//        
//        // 将第一张图片放到最后一个位置
//        UIImageView *firstImageView = [[UIImageView alloc] init];
//        firstImageView.frame = CGRectMake((SMImageCount + 1) * imageW, 0, imageW, imageH);
////        firstImageView.image = [UIImage imageNamed:@"yifu02"];
//        self.firstImageView = firstImageView;
//        [self.scrollView addSubview:firstImageView];
//        
//        // 设置滚动范围
//        self.scrollView.contentSize = CGSizeMake(imageW * (SMImageCount + 2), 0);
//        // 隐藏水平滚动条
//        self.scrollView.showsHorizontalScrollIndicator = NO;
//        // 分页
//        self.scrollView.pagingEnabled = YES;
//        // 设置偏移量
//        self.scrollView.contentOffset = CGPointMake(imageW, 0);
//        
//        // 添加分页指示器
//        [self addSubview:self.pageControl];
//        
//        // 设置当前页码
//        self.pageControl.currentPage = 0;
//        
//        // 开启定时器
//        [self addTimer];
//    }
//    return self;
//}

- (instancetype)initWithModel:(Product *)product{
    if (self = [super init]) {
        
        //通过模型 拿到图片个数
        NSArray *arrImages = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
        self.arrImages = arrImages;
        
        
        // 添加scrollView
        [self addSubview:self.scrollView];
        
        // 设置图片的宽高
        CGFloat imageW = CGRectGetWidth(self.scrollView.frame);
        CGFloat imageH = CGRectGetHeight(self.scrollView.frame);
        // 往scorllView添加3张图片
        for (int index = 0; index < self.arrImages.count ; index++) {
//#warning Bmob 这里设置图片
            // 获得图片的名字
            //            NSString *imageName = [NSString stringWithFormat:@"yifu0%d",index];
            //            NSString *imageName = @"yifu02";
            // 创建UIImageView
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.arrImageViews addObject:imageView];
            // 设置图片
            //            imageView.image = [UIImage imageNamed:imageName];
            imageView.userInteractionEnabled = YES;
//            imageView.contentMode = UIViewContentModeScaleAspectFit;

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClicked)];
            [self addGestureRecognizer:tap];
            
            //获取Bmob服务器上的数据
            
            
            // 设置frame
            CGFloat imageX = (index + 1) * imageW ; // 0 1 2
            CGFloat imageY = 0;
            
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            
            // 将图片添加到scrollView上面
            [self.scrollView addSubview:imageView];
        }
        
        
        
        
        // 将最后一张图片放到第一个位置
        UIImageView *lastImageView = [[UIImageView alloc] init];
        lastImageView.frame = CGRectMake(0, 0, imageW, imageH);
        lastImageView.contentMode = UIViewContentModeScaleAspectFit;
        // 设置图片
        //        lastImageView.image = [UIImage imageNamed:@"yifu02"];
        self.lastImageView = lastImageView;
        [self.scrollView addSubview:lastImageView];
        
        // 将第一张图片放到最后一个位置
        UIImageView *firstImageView = [[UIImageView alloc] init];
        firstImageView.frame = CGRectMake((self.arrImages.count + 1) * imageW, 0, imageW, imageH);
        firstImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        firstImageView.image = [UIImage imageNamed:@"yifu02"];
        self.firstImageView = firstImageView;
        [self.scrollView addSubview:firstImageView];
        
        
        //在这里，依次给创建出来的imageView 加载图片
        NSInteger count = self.arrImages.count;
        for (int i = 0; i < count; i++) {
            NSURL *url = [NSURL URLWithString:self.arrImages[i]];
            //[self.arrImageViews[i] sd_setImageWithURL:url];
             UIImageView * imageView1 = self.arrImageViews[i];
     
            
//            [imageView1 setShowActivityIndicatorView:YES];
//            [imageView1 setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [imageView1 sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
               
            }];
        }
        NSURL *lastUrl = [NSURL URLWithString:self.arrImages.lastObject];
        //[self.lastImageView sd_setImageWithURL:lastUrl];
        [self.lastImageView setShowActivityIndicatorView:YES];
        [self.lastImageView sd_setImageWithURL:lastUrl placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        NSURL *firstUrl = [NSURL URLWithString:self.arrImages.firstObject];
        //[self.firstImageView sd_setImageWithURL:firstUrl];
        
        [self.firstImageView setShowActivityIndicatorView:YES];
        [self.firstImageView sd_setImageWithURL:firstUrl placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
        // 设置滚动范围
        self.scrollView.contentSize = CGSizeMake(imageW * (self.arrImages.count + 2), 0);
        // 隐藏水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        // 分页
        self.scrollView.pagingEnabled = YES;
        // 设置偏移量
        self.scrollView.contentOffset = CGPointMake(imageW, 0);
        
        // 添加分页指示器
        [self addSubview:self.pageControl];
        
        // 设置当前页码
        self.pageControl.currentPage = 0;
        
        // 开启定时器 (只有一张图片的时候不开启滚动效果)
        if (self.arrImages.count > 1) {
            [self addTimer];
        }
    }
    return self;
}

//点了headerView 的图片之后的响应事件
- (void)imageViewDidClicked{
    
    //在代理方法中，把当前显示的是第几个图片传过去。
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedPage:)]) {
        [self.delegate headerViewDidClickedPage:self.currentSelectedPage];
    }
    
}


/**
 *  添加定时器
 */
- (void)addTimer{
    //     timerWithTimeInterval:该方法创建的定时器对象默认没有被添加到运行循环。要手动添加
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 只要将定时器对象添加到运行循环，就会自动开启定时器
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 *  移除定时器
 */
- (void)removeTimer{
    // 让定时器失效：一旦定时器失效。则不能再使用，只能重新创建一个新的定时器
    [self.timer invalidate];
    self.timer = nil;
}

/**
 * 定时器回调方法
 */
-(void)nextImage{
    //SMLog(@"nextImage");
    // 获得当前页码
    NSInteger page = self.pageControl.currentPage; // 0
    if (page == self.arrImages.count) {
        page = 0;
    } else {
        page ++; // 加 1
    }
    // 获得scrollView宽度
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    // 根据分页指示器当前的页码计算偏移量
    CGFloat offsetX = (page + 1) * width; // 300
    // 设置偏移量
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
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
    CGFloat width = CGRectGetWidth(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width;
    //    YCLog(@"offset = %zd",page);
    // 设置pageControl要显示页码
    self.pageControl.currentPage = --page;
    
    self.currentSelectedPage = self.pageControl.currentPage;
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


/**
 * 减速完毕时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 获得scrollView宽度
    CGFloat width = CGRectGetWidth(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width;
    if (page == self.arrImages.count + 1) { // 最后一张
        //        [scrollView setContentOffset:CGPointMake(width, 0)];
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO]; // 不能使用动画
    } else if (page == 0) {
        [scrollView setContentOffset:CGPointMake(self.arrImages.count * width, 0)];
    }
}

#pragma mark -- 懒加载
- (NSArray *)arrImages{
    if (_arrImages == nil) {
        _arrImages = [NSArray array];
    }
    return _arrImages;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        // 创建分页指示器
        _pageControl = [[UIPageControl alloc] init];
        // 设置点颜色(未选中点的颜色)
        _pageControl.pageIndicatorTintColor = SMColor(96, 95, 95);
        // 设置当前点的颜色
        _pageControl.currentPageIndicatorTintColor = SMColor(182, 0, 29);
        // 设置总页数
        _pageControl.numberOfPages = self.arrImages.count;
        // 设置frame
        
        CGFloat pageControlW = 150;
        CGFloat pageControlH = 20;
        CGFloat pageControlX = (CGRectGetWidth(self.frame) - pageControlW) * 0.5;
        CGFloat pageControlY = KScreenWidth - pageControlH - 10;
        // 监听pageControl点击
        [_pageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];
        
        _pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    }
    return _pageControl;
}

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        // 创建scrollView
        _scrollView = [[UIScrollView alloc] init];
        // 设置frame
        CGFloat scrollX = [UIScreen mainScreen].bounds.size.width;
        CGFloat scrollY = 0;
        CGFloat scrollW = CGRectGetWidth(self.frame) - scrollX;
        CGFloat scrollH = KScreenWidth;
        
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
        //设置背景颜色
        _scrollView.backgroundColor = [UIColor whiteColor];
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray *)arrImageViews{
    if (_arrImageViews == nil) {
        _arrImageViews = [NSMutableArray array];
    }
    return _arrImageViews;
}
@end
