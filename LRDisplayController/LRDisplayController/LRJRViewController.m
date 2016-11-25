//
//  LRJRViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRJRViewController.h"
#import "LRChildTableViewController.h"

@interface LRJRViewController ()

@end

@implementation LRJRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日头条";
    // 模仿网络延迟，0.2秒后，才知道有多少标题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //移除之前所有子控制器
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
        // 添加所有新的子控制器
        [self setUpAllViewController];
        // 注意：必须先确定子控制器
        [self refreshDisplay];
    });
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
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //默认选中中间那个
    self.selectIndex = 2;
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
