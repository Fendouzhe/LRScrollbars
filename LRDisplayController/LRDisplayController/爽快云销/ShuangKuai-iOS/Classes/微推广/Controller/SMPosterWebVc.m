//
//  SMPosterWebVc.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPosterWebVc.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SMPosterWebVc ()<UIWebViewDelegate>

@property (nonatomic ,strong)UIWebView *webView;/**< <#注释#> */

@property (nonatomic ,copy)NSString *baseUrl;/**< <#注释#> */

@end

@implementation SMPosterWebVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setUpWebView];
}

- (void)setUpWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.baseUrl = [NSString stringWithFormat:@"%@spread_poster_detail.html",SKAPI_PREFIX_SHARE];
    
    NSString *name = [self.listModel.adName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *imagePath = self.listModel.imagePath;
    NSString *fullStr = [NSString stringWithFormat:@"%@?n=%@&postSrc=%@&mobile=true&mode=1",self.baseUrl,name,imagePath];
    SMLog(@"fullStr  %@",fullStr);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullStr]]];
}

- (void)setupNav{
    
    self.title = @"微海报详情";
    
    UIButton *buttpon = [[UIButton alloc] init];
    [buttpon setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [buttpon addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    //    [buttpon sizeToFit];
    buttpon.size = ScaleToSize;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttpon];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]){
        NSString *str = [requestString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        SMLog(@"dict   %@",dict);
        
        if ([dict[@"action"] isEqualToString:@"getCodeInfo"]) {  //传参数  公司id userid 传给网页端
            
//            self.title = dict[@"params"][0];
//            self.posterTitle = dict[@"params"];
            
            NSString *comID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
            JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            
            SMLog(@"[NSString stringWithForm,comID,userID]   %@",[NSString stringWithFormat:@"getPic('%@','%@')",comID,userID]);
            NSString *textJS = [NSString stringWithFormat:@"getPic('%@','%@')",comID,userID];
            //            NSString *textJS = [NSString stringWithFormat:@"getPic(%@,%@)",comID,userID];
            [context evaluateScript:textJS];
        }
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

- (void)share{
    SMLog(@"share  分享");
}



@end
