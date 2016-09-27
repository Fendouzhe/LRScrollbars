//
//  SMTuiDataWebController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTuiDataWebController.h"
#import "SMScannerViewController.h"

@interface SMTuiDataWebController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation SMTuiDataWebController

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

    NSString *baseUrl = [NSString stringWithFormat:@"%@/app/user_promotion_data_page.html?user=%@",SKAPI_PREFIX_SHARE,[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SMLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    NSArray *components = [request.URL.absoluteString componentsSeparatedByString:@":"];
    SMLog(@"components===%@",components);
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
        NSString *str = [request.URL.absoluteString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        SMLog(@"dict == %@",dict);
        if ([dict[@"action"] isEqualToString:@"toSign"]) {//数据签到
            SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
            [self.navigationController pushViewController:scannerVc animated:YES];
        }
        return NO;
    }
    return YES;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil){
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        SMLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}
@end
