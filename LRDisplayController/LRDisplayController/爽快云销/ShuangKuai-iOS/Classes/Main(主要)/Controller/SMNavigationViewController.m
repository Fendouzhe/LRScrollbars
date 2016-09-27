//
//  SMNavigationViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/9.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNavigationViewController.h"

@interface SMNavigationViewController ()<UIGestureRecognizerDelegate>

 @property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;
@end

@implementation SMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiaoWhiteNew"] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
    //设置标题属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:KNavTitleFont *SMMatchWidth];
    //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"注册" attributes:dict];
    [self.navigationBar setTitleTextAttributes:dict];
    
    //设置左右导航栏按钮属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *attribute1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:KBlackColorLight};
    NSDictionary *attribute2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    [item setTitleTextAttributes:attribute1 forState:UIControlStateNormal];
    [item setTitleTextAttributes:attribute2 forState:UIControlStateDisabled];
    
//    self.navigationBar.tintColor = [UIColor whiteColor];
    //设置返回按钮<颜色
//    [self.navigationBar setTintColor:KRedColorLight];
//    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    
//    //获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
    
    //去掉底部分割线
//    self.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationBar.translucent = YES;
//    [self.navigationBar setShadowImage:[UIImage new]];
}

//作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{  // 注意：只有非根控制器才有滑动返回功能，根控制器没有。  // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//     CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];  //获取到滑动的点  判断是向右滑触发 其他不触发
//    if (self.childViewControllers.count == 1) {    // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    if(point.x>0){
//        return YES;
//    }
//    return NO;
//}


//拦截push事件
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        //viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"fanhuihong" highImage:@"fanhuihong"];
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav_back" highImage:@"nav_back"];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}


@end
