//
//  SMEmotionListView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionListView.h"
#import "SMEmotionPageView.h"

@interface SMEmotionListView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end
@implementation SMEmotionListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        //        scrollView.backgroundColor = [UIColor redColor];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        //把这两个属性设为NO之后，遍历 scrollView 子控件，就不会出现这两个东西干扰了
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        //这个设置NO ，用户就不可以主动点下面的分页点点了
        pageControl.userInteractionEnabled = NO;
        
        //自定义内部圆点的图片. 这两个属性是私有属性，所以需要用KVC 来设置
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}

// 拿到emotions 就可以知道一共有多少个表情
- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    //固定的公式
    NSUInteger count = (emotions.count + HWEmotionPageSize - 1) / HWEmotionPageSize;
    self.pageControl.numberOfPages = count;
    
    //每一页 ，都用一个UIView 的父控件来装
    for (int i = 0; i < count; i++) {
        
        SMEmotionPageView *pageView = [[SMEmotionPageView alloc] init];
        NSRange range;
        range.location = i * HWEmotionPageSize;
        NSUInteger left = emotions.count - range.location;
        
        if (left >= HWEmotionPageSize) {
            range.length = HWEmotionPageSize;
        }else{
            range.length = left;
        }
        
        //从一个数组中截取某个范围出来，作为一个新的数组
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    //scrollView 每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        
        UIView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i ;
        pageView.y = 0;
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

//计算 pageControl 当前显示哪一页。 四舍五入。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}


@end
