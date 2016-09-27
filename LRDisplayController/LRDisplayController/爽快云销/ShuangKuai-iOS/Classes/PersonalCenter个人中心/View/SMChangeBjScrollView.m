//
//  SMChangeBjScrollView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChangeBjScrollView.h"

@interface SMChangeBjScrollView ()

@property (nonatomic ,strong)UIScrollView *scrollView;

@end

@implementation SMChangeBjScrollView

+ (instancetype)changeBjScrollView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        // 创建scrollView
        _scrollView = [[UIScrollView alloc] init];
        // 设置frame
        CGFloat scrollX = [UIScreen mainScreen].bounds.size.width;
        CGFloat scrollY = 0;
        CGFloat scrollW = CGRectGetWidth(self.frame) - scrollX;
        CGFloat scrollH = 294;
        
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
        //设置背景颜色
        _scrollView.backgroundColor = [UIColor whiteColor];
        // 设置代理
//        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
