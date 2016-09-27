//
//  SMGuideViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMGuideViewController.h"
#import "SMLoginViewController.h"
#import "SMAVController.h"
#define SMNewfeatureCount 4

@interface SMGuideViewController ()<UIScrollViewDelegate>

@property(nonatomic ,weak)UIScrollView *scrollView;


@end

@implementation SMGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [self setupJumpOutBtn];
    
    //添加图片到scrollView
    CGFloat scrollW = scrollView.width;
    CGFloat scroolH = scrollView.height;
    
    for (int i = 0; i < SMNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //设置里面照片的尺寸
        imageView.width = scrollW;
        imageView.height = scroolH;
        imageView.x = i * scrollW;
        imageView.y = 0;
        
        NSString *name = [NSString stringWithFormat:@"new%d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        //判断是最后一张图片
        if (i == SMNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    scrollView.contentSize = CGSizeMake(SMNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;

}

- (void)setupJumpOutBtn{
    UIButton *jumpOutBtn = [[UIButton alloc] init];
    jumpOutBtn.backgroundColor = KGrayColorSeparatorLine;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = KDefaultFontBig;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"跳过" attributes:dict];
    [jumpOutBtn setAttributedTitle:str forState:UIControlStateNormal];
    jumpOutBtn.layer.cornerRadius = SMCornerRadios;
    jumpOutBtn.clipsToBounds = YES;
    jumpOutBtn.alpha = 0.7;
    
    
    [self.view addSubview:jumpOutBtn];
    CGFloat btnW = 60;
    CGFloat btnH = 25;
    CGFloat btnX = KScreenWidth - btnW - 15;
    CGFloat btnY = 15;
    jumpOutBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [jumpOutBtn addTarget:self action:@selector(jumpOut) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpOut{
    SMLog(@"跳过");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[SMLoginViewController alloc] init];
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupLastImageView:(UIImageView *)imageView;{
    
    //先打开imageVIew的交互功能，这样才能有点击事件
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastImageClick)];
    [imageView addGestureRecognizer:tap];
    
}

- (void)lastImageClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[SMLoginViewController alloc] init];
//    window.rootViewController = [[SMAVController alloc] init];
    
//    SMAVController *vc = [[SMAVController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
