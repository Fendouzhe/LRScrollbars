//
//  SMAdViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/29.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMAdViewController.h"
#import "AppDelegate.h"
@interface SMAdViewController ()

@end

@implementation SMAdViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广告";
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.imagePath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];

}



@end
