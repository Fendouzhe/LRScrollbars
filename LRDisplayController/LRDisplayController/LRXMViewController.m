//
//  LRXMViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRXMViewController.h"
#import "LRFullChildTableViewController.h"

@interface LRXMViewController ()

@end

@implementation LRXMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有子控制器
    [self setUpAllViewController];
    // 设置标题字体
    /*
     方式一：
     self.titleFont = [UIFont systemFontOfSize:20];
     */
    //方式2
    [self setupTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *normalColor, UIColor *__autoreleasing *selectColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight) {
        //设置字体
        *titleFont = [UIFont systemFontOfSize:18];
    }];
    //设置下划线view
    //方式1
//    self.isShowUnderLine = YES;
//    self.underLineColor = [UIColor redColor];
//    //设置下划线是否延时滚动,下标不会随着拖动而移动，等拖动完毕才滚动
//    self.isDelayScroll = YES;
    //方式2 推荐
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        *isShowUnderLine = YES;
        *underLineColor = [UIColor redColor];
        //设置下划线是否延时滚动,下标不会随着拖动而移动，等拖动完毕才滚动到指定标签位置
        //*isDelayScroll = YES;
    }];
    
    /*方式一
     // 标题渐变
     self.isShowTitleGradient = YES;
     // 标题填充模式
     self.titleColorGradientStyle = LRTitleColorGradientStyleFill;
     */
    /*  方式二 */
    [self setUpTitleGradient:^(BOOL *isShowTitleGradient, LRTitleColorGradientStyle *titleColorGradientStyle, CGFloat *startR, CGFloat *startG, CGFloat *startB, CGFloat *endR, CGFloat *endG, CGFloat *endB) {
        //标题渐变
        *isShowTitleGradient = YES;
        //标题填充模式
        *titleColorGradientStyle = LRTitleColorGradientStyleFill;
    }];
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    self.isfullScreen = YES;
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    // 段子
    LRFullChildTableViewController *wordVc1 = [[LRFullChildTableViewController alloc] init];
    wordVc1.title = @"新闻";
    [self addChildViewController:wordVc1];
    
    // 段子
    LRFullChildTableViewController *wordVc2 = [[LRFullChildTableViewController alloc] init];
    wordVc2.title = @"财经";
    [self addChildViewController:wordVc2];
    
    // 段子
    LRFullChildTableViewController *wordVc3 = [[LRFullChildTableViewController alloc] init];
    wordVc3.title = @"体育";
    [self addChildViewController:wordVc3];
    
    LRFullChildTableViewController *wordVc4 = [[LRFullChildTableViewController alloc] init];
    wordVc4.title = @"奋斗者";
    [self addChildViewController:wordVc4];
    
    // 全部
    LRFullChildTableViewController *allVc = [[LRFullChildTableViewController alloc] init];
    allVc.title = @"健康养生";
    [self addChildViewController:allVc];
    
    // 视频
    LRFullChildTableViewController *videoVc = [[LRFullChildTableViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 声音
    LRFullChildTableViewController *voiceVc = [[LRFullChildTableViewController alloc] init];
    voiceVc.title = @"声音";
    [self addChildViewController:voiceVc];
    
    // 图片
    LRFullChildTableViewController *pictureVc = [[LRFullChildTableViewController alloc] init];
    pictureVc.title = @"图片";
    [self addChildViewController:pictureVc];
    
    // 段子
    LRFullChildTableViewController *wordVc = [[LRFullChildTableViewController alloc] init];
    wordVc.title = @"段子";
    [self addChildViewController:wordVc];
    
}

@end
