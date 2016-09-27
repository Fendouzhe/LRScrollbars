//
//  SMRepostView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMRepostView.h"
#import <UIImageView+WebCache.h>

@interface SMRepostView ()

@property (nonatomic ,strong)UIButton *bgGrayBtn;

@end

@implementation SMRepostView

+ (instancetype)repostView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //整体的灰色view
        UIView *grayView = [[UIView alloc] init];
        self.grayView = grayView;
        grayView.backgroundColor = KControllerBackGroundColor;
        [self addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        
//        UIImageView *bgGrayView = [[UIImageView alloc] init];
//        bgGrayView.image = [UIImage imageNamed:@"bgGrayView"];
//        self.bgGrayView = bgGrayView;
//        bgGrayView.userInteractionEnabled = YES;
//        [grayView addSubview:bgGrayView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetTitleImageClick)];
//        [bgGrayView addGestureRecognizer:tap];
        
//        UIButton *bgGrayBtn = [[UIButton alloc] init];
//        self.bgGrayBtn = bgGrayBtn;
//        [grayView addSubview:bgGrayBtn];
////        [bgGrayBtn setBackgroundImage:[UIImage imageNamed:@"bgGrayView"] forState:UIControlStateNormal];
//        bgGrayBtn.backgroundColor = KRedColor;
//        [bgGrayBtn addTarget:self action:@selector(retweetTitleImageClick) forControlEvents:UIControlEventTouchUpInside];
        
        //左边图片
        UIImageView *leftImageView = [[UIImageView alloc] init];
          self.leftImageView = leftImageView;
        [grayView addSubview:leftImageView];
        
        
        //右边文字
        UILabel *rightLabel = [[UILabel alloc] init];
        self.rightLabel = rightLabel;
        [grayView addSubview:rightLabel];
        rightLabel.font = KDefaultFont;
        
    }
    return self;
}

- (void)retweetTitleImageClick{
    SMLog(@"retweetTitleImageClick");
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //灰色view
    CGFloat grayViewX = 12;
    CGFloat grayViewH = 55;
    self.grayView.frame = CGRectMake(grayViewX, 0, KScreenWidth - grayViewX * 2, 55);
    
    self.bgGrayBtn.frame = self.grayView.bounds;
    
    //左边图片
    CGFloat leftImageViewXY = 5;
    CGFloat leftImageViewW = 50;
    CGFloat leftImageViewH = 42;
    self.leftImageView.frame = CGRectMake(leftImageViewXY, leftImageViewXY, leftImageViewW, leftImageViewH);
    
    //右边label
    CGFloat rightLabelX =leftImageViewW + leftImageViewXY *2;
    CGFloat rightLabelW = KScreenWidth - leftImageViewW - leftImageViewXY *3;
    CGFloat rightLabelY = leftImageViewXY + leftImageViewXY;
    CGFloat rightLabelH = grayViewH - rightLabelY *2;
    
    self.rightLabel.frame = CGRectMake(rightLabelX, rightLabelY, rightLabelW, rightLabelH);
    
}


- (void)setImageAndLabel:(Tweet *)tweet{
    SMLog(@"tweet   %@",tweet);
    NSString * imageStr = tweet.datas.firstObject;
    //[self.leftImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    [self.leftImageView setShowActivityIndicatorView:YES];
    [self.leftImageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
//    self.rightLabel.text = tweet.repostFrom;
        self.rightLabel.text = tweet.content;
}
@end
