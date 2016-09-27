//
//  SMInComeDataWebController.m
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/8/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMInComeDataWebController.h"
#import <Pingpp.h>

@interface SMInComeDataWebController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation SMInComeDataWebController

- (void)loadView{
    self.view = [[UIWebView alloc] init];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据台";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置尺寸
//    btn.frame = CGRectMake(0, 0, 60, 22);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [btn setTitleColor:KBlackColorLight forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = (UIWebView *)self.view;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizesSubviews = YES;
//    NSString *baseUrl = [NSString stringWithFormat:@"%@sk_app_user_data_page.html",SKAPI_PREFIX_SHARE];
//    NSString *paramater = [NSString stringWithFormat:@"?user=%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]];
//    NSString *baseUrl = [NSString stringWithFormat:@"%@sk_app_user_data_page.html?user=%@&mode=%lu",SKAPI_PREFIX_SHARE,[[NSUserDefaults standardUserDefaults] objectForKey:KUserID],self.mode];
    NSString *baseUrl = [NSString stringWithFormat:@"%@/app/user_data_page.html?user=%@&mode=%lu",SKAPI_PREFIX_SHARE,[[NSUserDefaults standardUserDefaults] objectForKey:KUserID],self.mode];
//    NSString *unreserved = @"-._~/?";
//    NSMutableCharacterSet *allowed = [NSMutableCharacterSet alphanumericCharacterSet];
//    [allowed addCharactersInString:unreserved];
//    NSString *yu = [SKAPI_Short_PREFIX stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    NSString *yu = SKAPI_Short_PREFIX;
    NSString *urlChang1 = [yu stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    yu = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString *paramater = [NSString stringWithFormat:@"&api=%@",yu];
    NSString *requstUrl = [baseUrl stringByAppendingString:paramater];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requstUrl]]];
    SMLog(@"requstUrl %@",requstUrl);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
