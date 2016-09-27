//
//  LRWYViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRWYViewController.h"
#import "LRChildTableViewController.h"

@interface LRWYViewController ()

@end

@implementation LRWYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网易新闻";
    //添加所有子控制器
    [self setUpAllViewController];
    //标题渐变
    //方式1
//    self.isShowTitleGradient = YES;
//    self.titleColorGradientStyle = LRTitleColorGradientStyleRGB;
//    self.endR = 1;
    //方式2  推荐方式
    [self setUpTitleGradient:^(BOOL *isShowTitleGradient, LRTitleColorGradientStyle *titleColorGradientStyle, CGFloat *startR, CGFloat *startG, CGFloat *startB, CGFloat *endR, CGFloat *endG, CGFloat *endB) {
        *isShowTitleGradient = YES;
        *titleColorGradientStyle = LRTitleColorGradientStyleRGB;
        *endR = 1;
    }];
    //字体缩放
    //方式1
//    self.isShowTitleScale = YES;
//    self.titleScale = 1.3;
    //方式2 推荐方式
    [self setUpTitleScale:^(BOOL *isShowTitleScale, CGFloat *titleScale) {
        *isShowTitleScale = YES;
        *titleScale = 1.3;
    }];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    // 段子
    LRChildTableViewController *wordVc1 = [[LRChildTableViewController alloc] init];
    wordVc1.title = @"新闻";
    [self addChildViewController:wordVc1];
    
    // 段子
    LRChildTableViewController *wordVc2 = [[LRChildTableViewController alloc] init];
    wordVc2.title = @"财经";
    [self addChildViewController:wordVc2];
    
    // 段子
    LRChildTableViewController *wordVc3 = [[LRChildTableViewController alloc] init];
    wordVc3.title = @"体育";
    [self addChildViewController:wordVc3];
    
    LRChildTableViewController *wordVc4 = [[LRChildTableViewController alloc] init];
    wordVc4.title = @"奋斗者";
    [self addChildViewController:wordVc4];
    
    // 全部
    LRChildTableViewController *allVc = [[LRChildTableViewController alloc] init];
    allVc.title = @"健康养生";
    [self addChildViewController:allVc];
    
    // 视频
    LRChildTableViewController *videoVc = [[LRChildTableViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 声音
    LRChildTableViewController *voiceVc = [[LRChildTableViewController alloc] init];
    voiceVc.title = @"声音";
    [self addChildViewController:voiceVc];
    
    // 图片
    LRChildTableViewController *pictureVc = [[LRChildTableViewController alloc] init];
    pictureVc.title = @"图片";
    [self addChildViewController:pictureVc];
    
    // 段子
    LRChildTableViewController *wordVc = [[LRChildTableViewController alloc] init];
    wordVc.title = @"段子";
    [self addChildViewController:wordVc];
    
}
@end
