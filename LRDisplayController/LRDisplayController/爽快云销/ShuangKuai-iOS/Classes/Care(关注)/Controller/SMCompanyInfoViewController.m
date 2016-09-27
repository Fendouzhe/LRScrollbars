//
//  SMCompanyInfoViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCompanyInfoViewController.h"
#import "SMSearchBar.h"
#import "SMScanerBtn.h"
#import <MBProgressHUD.h>
#import "SMScannerViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"

#define KwebStr @"http://192.168.1.44/sk/sk_company.html"
@interface SMCompanyInfoViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>

@property (nonatomic ,strong)SMSearchBar *searchBar;

@property (nonatomic ,strong)UIWebView *webView;

@property (nonatomic ,strong)MBProgressHUD *HUD;

//webView当前加载的url
@property (strong,nonatomic)NSString *currentURL;
//webView当前加载的url 的title
@property (strong,nonatomic)NSString *currentTitle;

@end

@implementation SMCompanyInfoViewController


#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    //    [self.searchBar resignFirstResponder];
}

- (void)dealloc{
    SMLog(@"企业页面 销毁");
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark -- 懒加载
- (MBProgressHUD *)HUD{
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HUD.delegate = self;
    }
    return _HUD;
}

- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.bounces=NO;
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearWebViewCache];
    
    [self.view addSubview:self.HUD];
    
    //    [self setupNav];
    [self setupWebView];
    
    self.view.backgroundColor = KBatteryBarColor;
    
    
}

- (void)clearWebViewCache{
    //清除webView上的所有缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)setupWebView{
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    //    NSURL *url = [NSURL URLWithString:@"http://sale.jd.com/act/M7J62hoy1vugS.html?cu=true&utm_source=kong&utm_medium=tuiguang&utm_campaign=t_291540637_baidu_ads&utm_term=608055900dcb46a38b205915f631e5b7-p_532"];
    NSString *webStr = KwebStr;
    NSString *para = @"?Mode=1";
    NSString *loadStr = [webStr stringByAppendingString:para];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.44/sk/sk_company.html?mode=1"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

//- (void)setupNav{
//
//    //搜索栏
//    SMSearchBar *searchBar = [SMSearchBar searchBar];
//    self.searchBar = searchBar;
//    searchBar.width = 210;
//    searchBar.height = 22;
//    self.navigationItem.titleView = searchBar;
//
//    //二维码
//    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
//    //给搜索栏的显示长度做一个适配
//    CGFloat width = 180;
//    if (isIPhone5) {
//        width = 210;
//    }else if (isIPhone6){
//        width = 270;
//    }else if (isIPhone6p){
//        width = 300;
//    }
//    searchBar.width = width;
//    searchBar.height = 28;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//
//}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.HUD.color = [UIColor greenColor];
    self.HUD.labelText = @"客官";
    self.HUD.detailsLabelText = @"小的正在玩命加载...";
    [self.HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.HUD hide:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![self.searchBar isExclusiveTouch]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)scanerBtnDidClick{
    [self.searchBar resignFirstResponder];
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

#pragma mark -- UIWebViewDelegate    iOS 与 JS 交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    SMLog(@"%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
        SMLog(@"iOS 与 JS 交互");
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"pageBack"]){
            
            // 返回页面
            SMLog(@"执行返回代码");
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"sharePage"]){
            
            SMLog(@"执行分享代码");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
            self.currentURL = webView.request.URL.absoluteString;
            SMLog(@"title-%@--url-%@--",self.title,self.currentURL);
            [self sharePage];
            
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"addToPromo"]){
            
            SMLog(@"执行 添加到微推广代码");
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"openQrcode"]){
            
            SMLog(@"执行 二维码扫描 代码");
        }
        return NO;
    }
    return YES;
}

- (void)sharePage{
    NSArray* imageArray = @[[UIImage imageNamed:@"爽快图标120"]];
    if (imageArray) {
        NSString *shareStr = [self.currentURL componentsSeparatedByString:@"?"].firstObject;
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"很不错的宝贝，快打开看看！"
                                         images:imageArray
                                            url:[NSURL URLWithString:shareStr]
                                          title:@"这个宝贝太棒了！"
                                           type:SSDKContentTypeAuto];
        SMLog(@"self.currentURL   %@",self.currentURL);
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}


@end
