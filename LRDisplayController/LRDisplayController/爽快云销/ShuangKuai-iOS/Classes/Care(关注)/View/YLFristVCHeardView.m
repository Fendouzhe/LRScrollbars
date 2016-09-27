//
//  YLFristVCHeardView.m
//  云联惠
//
//  Created by 薛养灿 on 15/10/13.
//  Copyright © 2015年 薛养灿. All rights reserved.
//

#import "YLFristVCHeardView.h"
#import "Reachability.h"
#import <MagicalRecord/MagicalRecord.h>
#import "LocalAd+CoreDataProperties.h"

/**
 *  图片的总数量
 */
//#define YLImageCount 3

@interface YLFristVCHeardView()<UIScrollViewDelegate>
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
 *  装模型的数组
 */
@property (nonatomic ,strong)NSMutableArray *arrModels;
/**
 *  图片总数量
 */
@property (nonatomic ,assign)NSInteger imageCount;

/**
 *  用于检查网络
 */
@property (nonatomic ,strong)Reachability *reach;

@property(nonatomic,strong)NSFileManager * fileManager;

@property(nonatomic,assign)NSInteger isOnline;

@end

@implementation YLFristVCHeardView



- (instancetype)init{
    if(self = [super init]){
        
        // 添加scrollView
        [self addSubview:self.scrollView];
        
        /**
         *  检查网络
         */
        //        self.reach = [Reachability reachabilityWithHostName:@"baidu.com"];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
        //        [self.reach startNotifier];
        
        [self loadSqlite];
        
        
        //[self setup];
        
        //[self getDatas];
        
        //[self getDatas];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"homePageRefresh" object:nil];
        
        
    }
    return self;
}

-(void)refreshData
{
    [self getDatas];
}

- (void)setup{
    for (UIView * view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    // 设置图片的宽高
    CGFloat imageW = CGRectGetWidth(self.scrollView.frame);
    CGFloat imageH = CGRectGetHeight(self.scrollView.frame);
    // 往scorllView添加5张图片
    for (int index = 0; index < self.imageCount ; index++) {
#warning Bmob 这里设置图片
        
        // 获得图片的名字
        //            NSString *imageName = [NSString stringWithFormat:@"产品%d",index + 1];
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置图片
        NSString *imageStr = [self.arrModels[index] imagePath];
        
        //[imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        
        [imageView setShowActivityIndicatorView:YES];
        [imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        //SMLog(@"imageStr   %@",imageStr);
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClicked)];
        [self addGestureRecognizer:tap];
        
        //获取Bmob服务器上的数据
        
        
        // 设置frame
        CGFloat imageX = (index + 1) * imageW ; // 0 1 2
        CGFloat imageY = 0;
        
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 将图片添加到scrollView上面
        [self.scrollView addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    // 将最后一张图片放到第一个位置
    UIImageView *lastImageView = [[UIImageView alloc] init];
    lastImageView.frame = CGRectMake(0, 0, imageW, imageH);
//    lastImageView.contentMode = UIViewContentModeScaleAspectFit;
    // 设置图片
    
    NSString *lastPath = [self.arrModels.lastObject imagePath];
    //[lastImageView sd_setImageWithURL:[NSURL URLWithString:lastPath]];
    
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:lastPath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [self.scrollView addSubview:lastImageView];
    
    // 将第一张图片放到最后一个位置
    UIImageView *firstImageView = [[UIImageView alloc] init];
//    firstImageView.contentMode = UIViewContentModeScaleAspectFit;
    firstImageView.frame = CGRectMake((self.imageCount + 1) * imageW, 0, imageW, imageH);
    NSString *firstPath = [self.arrModels.firstObject imagePath];
    //[firstImageView sd_setImageWithURL:[NSURL URLWithString:firstPath]];
    
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstPath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [self.scrollView addSubview:firstImageView];
    
    // 设置滚动范围
    self.scrollView.contentSize = CGSizeMake(imageW * (self.imageCount + 2), 0);
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
    
    // 开启定时器
    [self addTimer];
    
}

- (void)getDatas{
    
    [self removeTimer];
    
    [[SKAPI shared] queryAd:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrModels removeAllObjects];
            SMLog(@"请求成功");
                NSArray * LocalArray = [LocalAd MR_findAll];
                for (LocalAd * model in LocalArray) {
                    [model MR_deleteEntity];
                }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            for (Ad * adModel in array) {
                [self.arrModels addObject:adModel];
            }
            self.imageCount = self.arrModels.count;
            [self setup];
            
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
                for (Ad * adModel in array) {
                        LocalAd * localAd = [LocalAd MR_createEntityInContext:localContext];
                        localAd.id = adModel.id;
                        localAd.link = adModel.link;
                        localAd.imagePath = adModel.imagePath;
                        localAd.adName = adModel.adName;
                        localAd.createAt = [NSNumber numberWithInteger:adModel.createAt];
                    }
                    
                } completion:^(BOOL contextDidSave, NSError *error) {
                    
                }];
            
        
            
            
            SMLog(@"self.arrModels  %@",self.arrModels);
            
            self.imageCount = self.arrModels.count;
        }else{
            SMLog(@"请求失败");
//            NSArray * localArray = [LocalAd MR_findAll];
//                for (LocalAd * adModel in localArray) {
//                    [self.arrModels addObject:adModel];
//            }
//            self.imageCount = localArray.count;
//            SMLog(@"Adv = %@",localArray);
            
        }
    }];
}

//点了headerView 的图片之后的响应事件
- (void)imageViewDidClicked{
    NSString *imagePath = [self.arrModels[self.currentSelectedPage] link];
    
    //在代理方法中，把当前显示的是第几个图片传过去。
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedPage:imagePath:)]) {
        [self.delegate headerViewDidClickedPage:self.currentSelectedPage imagePath:imagePath];
    }
    
}

/**
 *  添加定时器
 */
- (void)addTimer{
    //     timerWithTimeInterval:该方法创建的定时器对象默认没有被添加到运行循环。要手动添加
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
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
    // 获得当前页码
    NSInteger page = self.pageControl.currentPage; // 0
    if (page == self.imageCount) {
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
    if (page == self.imageCount + 1) { // 最后一张
        //        [scrollView setContentOffset:CGPointMake(width, 0)];
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO]; // 不能使用动画
    } else if (page == 0) {
        [scrollView setContentOffset:CGPointMake(self.imageCount * width, 0)];
    }
}

#pragma mark -- 懒加载

-(NSMutableArray *)arrModels
{
    if (!_arrModels) {
        _arrModels = [NSMutableArray array];
    }
    return _arrModels;
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
        _pageControl.numberOfPages = self.imageCount;
        // 设置frame
        
        CGFloat pageControlW = 150;
        CGFloat pageControlH = 20;
        CGFloat pageControlX = (CGRectGetWidth(self.frame) - pageControlW) * 0.5;
        CGFloat pageControlY;
        
        if (isIPhone5) {
            pageControlY = 110;
        }else if (isIPhone6){
            pageControlY = 110 *KMatch6;
        }else if (isIPhone6p){
            pageControlY = 110 *KMatch6p;
        }
        
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
        CGFloat scrollH;
        if (isIPhone5) {
            scrollH = KDiscoverLunBoH;
        }else if (isIPhone6){
            scrollH = KDiscoverLunBoH *KMatch6;
        }else if (isIPhone6p){
            scrollH = KDiscoverLunBoH *KMatch6p;
        }
        
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
        //设置背景颜色
//        _scrollView.backgroundColor = [UIColor orangeColor];
        
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

/**
 *  监听分页指示器值的改变
 */
- (void)pageControlValueChanged{
    //YCLog(@"pageControlValueChanged");
}

#pragma mark - 判断网络状态
- (void)reachabilityChanged{
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
        {
            SMLog(@"没有联网");
            self.isOnline = 0;
           
        }
            break;
        case ReachableViaWiFi:
        {
            SMLog(@"wifi上网");
            self.isOnline = 1;
           
        }
            break;
        case ReachableViaWWAN:
            //手机上模拟才写的这段代码，后面可以删掉这句代码
        {
            SMLog(@"手机流量上网");
            self.isOnline = 2;
            
        }
            break;
        default:
            break;
    }
    //[self getDatas];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

-(void)loadSqlite
{
    NSArray * array = [LocalAd MR_findAll];
    if (array.count>0) {
        [self.arrModels removeAllObjects];
        for (LocalAd * localad in array) {
            Ad * admodel = [Ad new];
            admodel.id = localad.id;
            admodel.link = localad.link;
            admodel.imagePath = localad.imagePath;
            admodel.adName = localad.adName;
            admodel.createAt =localad.createAt.integerValue;
            [self.arrModels addObject:admodel];
        }
        self.imageCount = self.arrModels.count;
        [self setup];
        //[self getDatas];
    }else
    {
        [self getDatas];
        //[self setup];
    }
    
}
@end
