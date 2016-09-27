//
//  SMScannerJumpViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMScannerJumpViewController.h"

@interface SMScannerJumpViewController ()

@property (nonatomic ,strong)UIWebView *webView;

@end

@implementation SMScannerJumpViewController

#pragma mark -- 懒加载
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight)];
        _webView.scrollView.bounces=NO;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描结果";
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
}



@end
