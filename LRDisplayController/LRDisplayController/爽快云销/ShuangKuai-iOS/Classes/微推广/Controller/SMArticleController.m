//
//  SMArticleController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//     

#import "SMArticleController.h"
#import "WebConsole.h"
#import "SMShareToWXMenu.h"
#import <ShareSDK/ShareSDK.h>
#import "SMShareMenu.h"
#import "SMNewFav.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SMShareMenu.h"

@interface SMArticleController ()<SMShareMenuDelegate,UIWebViewDelegate,UIScrollViewDelegate,SMShareToWXMenuDelegate,SMShareMenuDelegate>

@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic ,strong)MBProgressHUD *HUD;
@property (nonatomic ,strong)UIView *cheatView;
@property (nonatomic ,strong)SMShareMenu *menu;
@property (nonatomic ,copy)NSString *currentUrlStr;

@property (nonatomic ,copy)NSString *articleTitle;

@property (nonatomic ,strong)UIView *cheatView2;/**< 蒙板 */

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,copy)NSString *urlstr;

@end

@implementation SMArticleController

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章推广";
    
    [self setupWebview];
    
    [self setupLeftItem];
    
    
}

- (void)setupRightItem{
    UIButton *buttpon = [[UIButton alloc] init];
    [buttpon setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [buttpon addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [buttpon sizeToFit];
    buttpon.size = ScaleToSize;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttpon];
}

- (void)setupWebview{
    //    http://192.168.1.49:8088/shuangkuai_app/spread_news.html
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    [self.view addSubview:webView];
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    //self.webView.scrollView.delegate = self;
    self.webView = webView;
    webView.delegate = self;
//    NSString *baseUrl = @"http://m.shuangkuai.co/shuangkuai_app/spread_news.html";
    NSString *baseUrl = [NSString stringWithFormat:@"%@spread_news.html",SKAPI_PREFIX_SHARE];
    NSString *comID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    int randomNum = arc4random_uniform(1000000);
    NSString *urlStr = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"?comId=%@&t=%zd",comID,randomNum]];
    SMLog(@"urlStr   %@",urlStr);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)setupLeftItem{
    UIButton *leftBtn = [[UIButton alloc] init];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"fenxiangRed"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)leftItemClick{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.title = @"文章推广";
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -- 点击事件
- (void)share{
    //http://tm.shuangkuai.co/shuangkuai_app/sk_promotion.html?uid=YZLD011&pid=a05a8f5fa59648b59f8a80971ad99da6&mobile=true
    //
    SMLog(@"%s--->>>%@",__func__,_webView.request.URL.absoluteString);
    
    self.urlstr = _webView.request.URL.absoluteString;
    
    if (self.cheatView3) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    UIView *cheatView3 = [[UIView alloc] init];
    self.cheatView3 = cheatView3;
    
    cheatView3.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCheatView3)];
    [cheatView3 addGestureRecognizer:tap];
    cheatView3.frame = window.bounds;
    
    SMShareMenu *menu3 = [SMShareMenu shareMenu];
    [menu3 onlyShowWeiXinShare];
    menu3.delegate = self;
    [window addSubview:menu3];
    self.menu3 = menu3;
    [self.menu3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@300);
        make.height.equalTo(@270);
        
    }];
    
    // 动画
    cheatView3.alpha = 0;
    menu3.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        menu3.transform = CGAffineTransformMakeScale(1, 1);
        cheatView3.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SMLog(@"%s--->>>%@",__func__,request.URL.absoluteString);
   
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    SMLog(@"components===%@",components);
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
        //if ([request.URL.absoluteString rangeOfString:@"_list"].location != NSNotFound ) {
        NSString *str = [requestString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        SMLog(@"dict====>>%@",dict);
        
        //self.posterTitle = dict[@"params"];
        if ([dict[@"action"] isEqualToString:@"share_detail"]) {  //传参数  公司id userid 传给网页端
            self.title = dict[@"params"][0];
        }
        return NO;
        
    }else if([request.URL.query rangeOfString:@"mobile=true"].location == NSNotFound){
        NSString *str = request.URL.absoluteString;
        str = [str stringByAppendingString:@"&mobile=true"];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        return NO;
    }
    
    if ([requestString rangeOfString:@"imagePath"].location == NSNotFound) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }else{
        //self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        [self setupRightItem];
        
        NSString *str = request.URL.query;
        
        if([str rangeOfString:@"mobile=true"].location != NSNotFound){
            str = [str stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
        }
        NSRange range = [str rangeOfString:@"imagePath="];
        NSString *urlString = [str substringFromIndex:range.location + range.length];
        //_imageUrl = urlString;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        SMLog(@"_imageUrl = %@---image = %@",urlString,_image);
        self.image = [image scaleToSize:CGSizeMake(100, 100)];//[self scaleToSize:image size:CGSizeMake(100, 100)];

    }
    
    if ([request.URL.absoluteString rangeOfString:@"m.shuangkuai.co/shuangkuai_app/"].location == NSNotFound) { //web端那边更新ping＋＋后出现重复加载ping＋＋ 页面的情况，这里通过域名做一个拦截
        SMLog(@"没有找到  m.shuangkuai.co/shuangkuai_app/  域名   直接返回");
        return NO;
    }
    
    self.urlstr = request.URL.absoluteString;
    return YES;
}

//禁止webview左右滑动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint point = scrollView.contentOffset;
//    if (point.x>0 || point.x<0) {
//        [scrollView setContentOffset:CGPointMake(0, point.y)];
//    }
//}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    SMShowPrompt(@"");
    self.HUD = HUD;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.HUD hide:YES];
    self.HUD = nil;
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

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
    
    NSDate *localeDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SMLog(@"timeSp :%@",timeSp); //时间戳的值
    
    //取出照片：
//    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
//    UIImage* image = [UIImage imageWithData:imageData];
//    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
    NSArray* imageArray = @[_image];
    
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *para = [NSString stringWithFormat:@"&salenumber=%@&salecompany=%@&mode=1&share=1&uid=%@",userID,companyId,userID];
    NSString *urlChang5 = [self.urlstr stringByAppendingString:para];
    urlChang5 = [urlChang5 stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
    
    if (type == 24) {  //分享到QQ  截取掉前面的http://
        urlChang5 = [urlChang5 substringFromIndex:7];
    }
    
    //    SMLog(@"urlStr  substringFromIndex   %@",urlStr);
    //
    //    NSString *headStr = [[urlStr componentsSeparatedByString:@"&"] firstObject];
    //    SMLog(@"headStr   %@",headStr);
    //
    //    NSString *urlChang5;
    //    urlChang5 = [headStr stringByAppendingString:[NSString stringWithFormat:@"&mode=0&t=%@",timeSp]];
    //    SMLog(@"urlChang5   %@",urlChang5);
    
    /*
    if (type == 22) { //分享到微信
        NSString *urlChang1 = [urlChang5 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        
        urlChang5 = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:urlChang5 andMoreinfo:NO];
    }
    */
    
    SMLog(@"urlChang5  createOauthUrlForCode      %@",urlChang5);
    //NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.title
                                     images:imageArray
                                        url:[NSURL URLWithString:urlChang5]
                                      title:[NSString stringWithFormat:@"%@",self.title]
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                [self removeCheatView3];
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
    }];
}

- (void)removeCheatView3{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.menu3.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView3.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView3 removeFromSuperview];
        self.cheatView3 = nil;
        [self.menu3 removeFromSuperview];
        self.menu3 = nil;
    }];
}

#pragma mark -- SMShareMenuDelegate  分享
- (void)cancelBtnDidClick{
    [self removeCheatView3];
}





- (void)cheatViewTap{
    [self.cheatView removeFromSuperview];
    self.cheatView = nil;
    [self.menu removeFromSuperview];
    self.menu = nil;
}

#pragma mark -- 懒加载
- (UIView *)cheatView{
    if (_cheatView == nil) {
        _cheatView = [[UIView alloc] initWithFrame:self.view.bounds];
        _cheatView.backgroundColor = [UIColor grayColor];
        _cheatView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
        [_cheatView addGestureRecognizer:tap];
    }
    return _cheatView;
}

@end
