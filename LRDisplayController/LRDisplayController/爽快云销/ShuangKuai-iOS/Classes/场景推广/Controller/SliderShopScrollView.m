//
//  SliderShopScrollView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SliderShopScrollView.h"

@interface SliderShopScrollView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;/**< <#属性#> */
@property (nonatomic,assign) NSInteger currentIndex;/**< <#属性#> */
@end

@implementation SliderShopScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor redColor];
        scrollView.pagingEnabled = YES;
//        scrollView.showsHorizontalScrollIndicator = NO;
//        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
//    self.scrollView.frame = self.frame;
//    for (int i = 0; i < dataArray.count; i++) {
//        UIViewController *vc = dataArray[i];
//        [self.scrollView addSubview:vc.view];
//        vc.view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//    }
//    self.scrollView.contentSize = CGSizeMake(dataArray.count*self.frame.size.width, self.frame.size.height);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIViewController *vc = self.dataArray[i];
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    self.scrollView.contentSize = CGSizeMake(self.dataArray.count*self.frame.size.width, self.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = offsetX / CGRectGetWidth(self.frame);
    self.currentIndex = index;
    SMLog(@"当前页面数%d",index);
}

@end
