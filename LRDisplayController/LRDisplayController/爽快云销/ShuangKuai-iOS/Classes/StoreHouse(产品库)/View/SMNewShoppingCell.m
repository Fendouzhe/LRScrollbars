//
//  SMNewShoppingCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewShoppingCell.h"


@interface SMNewShoppingCell ()


@end

@implementation SMNewShoppingCell


- (void)setArrUrls:(NSArray *)arrUrls{
    _arrUrls = arrUrls;
    self.scrollView.imageURLStringsGroup = arrUrls;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        SDCycleScrollView *scrollView = [[SDCycleScrollView alloc] init];
        scrollView.pageDotImage = [UIImage imageNamed:@"yuandian"];
        scrollView.currentPageDotImage = [UIImage imageNamed:@"hongyuandian"];
        self.scrollView = scrollView;
        scrollView.placeholderImage = [UIImage imageNamed:@"220"];
        [self.contentView addSubview:scrollView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.contentView.bounds;
//    self.scrollView.frame = CGRectMake(10, 10, KScreenWidth - 20, KScreenHeight - 20);
}

@end
