//
//  LRTXViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRTXViewController.h"
#import "LRChildTableViewController.h"

@interface LRTXViewController ()



@end

@implementation LRTXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"腾讯视频";
    //有导航栏就设置64，没有就设置为状态栏底部y为20
    CGFloat y = self.navigationController ? 64 : [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    //设置搜索框
    CGFloat searchBarH = 44;
    //创建搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, y, screenW, searchBarH)];
    [self.view addSubview:searchBar];
    
    // 设置整体内容尺寸（包含标题滚动视图和底部内容滚动视图）
    [self setupContentViewFrame:^(UIView *contentView) {
        CGFloat contentY = CGRectGetMaxY(searchBar.frame);
        CGFloat contentH = screenH - contentY;
        contentView.frame = CGRectMake(0, contentY, screenW, contentH);
    }];
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    /****** 标题渐变 ******/
    /*
         方式一
         self.isShowTitleGradient = YES;
         self.endR = 1;
         self.endG = 130 / 255.0;
         self.endB = 44 / 255.0;
     */
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(BOOL *isShowTitleGradient, LRTitleColorGradientStyle *titleColorGradientStyle, CGFloat *startR, CGFloat *startG, CGFloat *startB, CGFloat *endR, CGFloat *endG, CGFloat *endB) {
        // 不需要设置的属性，可以不管
        //设置渐变
        *isShowTitleGradient = YES;
        // 设置结束时，RGB通道各个值
        *endR = 1;
        *endG = 130 / 255.0;
        *endB = 44 / 255.0;
    }];
    
    /****** 设置遮盖 ******/
    //    self.isShowTitleCover = YES;
    //    self.coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    //    self.coverCornerRadius = 13;
    // *推荐方式(设置遮盖)
    [self setUpCoverEffect:^(BOOL *isShowTitleCover, UIColor *__autoreleasing *coverColor, CGFloat *coverCornerRadius) {
        // 设置是否显示标题蒙版
        *isShowTitleCover = YES;
        // 设置蒙版颜色
        *coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        // 设置蒙版圆角半径
        *coverCornerRadius = 13;
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
