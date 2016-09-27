//
//  SMTogetherBuyWebVc.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTogetherBuyWebVc.h"
#import <ShareSDK/ShareSDK.h>
#import "SMNewFav.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SMShareMenu.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <Pingpp.h>
#import "SMSuccessOrFailViewController.h"

@interface SMTogetherBuyWebVc ()<UIWebViewDelegate,SMShareMenuDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)UIWebView *webView;/**< <#注释#> */

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;

@property(nonatomic,copy)NSString *urlstr;

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)UIImage *image;

@end

@implementation SMTogetherBuyWebVc

- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

//- (void)loadView{
//    self.view = [[UIWebView alloc] init];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    //self.webView.delegate = self;
    self.webView.scrollView.alwaysBounceHorizontal = NO;
    
    if (self.isSingle == YES) {//单品列表
        NSString *baseUrl = [NSString stringWithFormat:@"%@sk_combination.html",SKAPI_PREFIX_SHARE];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        NSString *para = [NSString stringWithFormat:@"?sid=%@&pid=%@&mobile=true&mode=1",userID,self.pId];
        NSString *loadStr = [baseUrl stringByAppendingString:para];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
        SMLog(@"loadStr  %@",loadStr);
    }else{//拼团放送列表
        NSString *baseUrl = [NSString stringWithFormat:@"%@sk_combination_list.html",SKAPI_PREFIX_SHARE];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        NSString *para = [NSString stringWithFormat:@"?uid=%@&pid=%@&mobile=true&mode=1",userID,self.pId];
        NSString *loadStr = [baseUrl stringByAppendingString:para];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
        SMLog(@"loadStr  %@",loadStr);
    }
    
    
    
    [self setupLeftItem];
    
    //[self setupRightItem];
    
    //移除分页指示器新消息动画动画
    [[NSNotificationCenter defaultCenter] postNotificationName:PageControlRemoveAnimationNotification object:nil userInfo:@{@"index":KPingTuanPage}];
    //移除已读的拼团推送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveReadedPushMessageNotification object:nil userInfo:@{@"type":@(KPingTuan_71)}];
    
    //移除滚动标题栏拼团消息红点
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTitleScrollViewTitleBageNotification object:nil userInfo:@{@"index":@(KNewPingTuanPage)}];
}

- (void)setupRightItem{
    UIButton *buttpon = [[UIButton alloc] init];
    [buttpon setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [buttpon addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [buttpon sizeToFit];
    buttpon.size = ScaleToSize;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttpon];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fenxiangRed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
}

/**
 *  分享
 */
- (void)share{
    //http://tm.shuangkuai.co/shuangkuai_app/sk_combination_list.html?uid=YZLD011&pid=6f4f8ba4331c4e31b6e0f0883fe71e74&mobile=true
    //http://tm.shuangkuai.co/shuangkuai_app/sk_combination.html?pid=4f656de5d0e14746b276b24584316c13&sid=YZLD011&t=1469169392798
    //SMLog(@"%s--->>>%@",__func__,_webView.request.URL.absoluteString);
    
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

/**
 *  设置返回按钮事件
 */
- (void)setupLeftItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    
}

- (void)leftItemClick{
////    if (self.isPush) {
////        [self dismissViewControllerAnimated:YES completion:nil];
////    }else{
//        if ([self.webView canGoBack]) {
////            [self.webView goBack];
//            [self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"];
//        }else{
//            [self.navigationController popViewControllerAnimated:YES];
//        }
////    }
    
    if (self.isSingle == YES) {//单品列表
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"];
        }
    }else{//拼团放送列表
        if ([self.webView canGoBack]) {
//            [self.webView goBack];
            [self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SMLog(@"   scheme = %@ shouldStartLoadWithRequest   url = %@",request.URL.scheme,request.URL.absoluteString);

    NSString *requestString = [[request URL] absoluteString];
//    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
//        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
//        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        //path 就是被点击图片的url
//        SMLog(@"image url=%@", path);
//        return NO;
//    }
    
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    SMLog(@"components===%@",components);
    //点击拼团玩法隐藏分享以及加载拼团玩法网页
    if ([requestString rangeOfString:@"_guide"].location != NSNotFound) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        return YES;
    }else{
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
    //if ([request.URL.absoluteString rangeOfString:@"_list"].location != NSNotFound ) {
        NSString *str = [requestString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        SMLog(@"拼团dict == %@",dict);
        
        if ([dict[@"action"] isEqualToString:@"share_detail"]) {  //导航栏显示 分享按钮
            [self setupRightItem];
        }
        //self.posterTitle = dict[@"params"];
        if ([dict[@"action"] isEqualToString:@"titleName"]) {  //传参数  公司id userid 传给网页端
            self.title = dict[@"params"][0];
        }else if ([dict[@"action"] isEqualToString:@"getOpenId"]){  //把openid 传给web  支付需要的
#pragma mark -- 这里实现思路：  先截取指令 getOpenId ，然后 调用JS getOpenIdSuccess('微信openid')方法  把自己的微信openId 传过去， 所以这里需要先进行微信登陆
            [self callOpenIdAndGiveItToWeb:webView];
            
        }else if ([dict[@"action"] isEqualToString:@"createPayment"]){ //  创建支付
#pragma mark -- 这里的实现思路： 先截取到指令 createPayment  然后  拿到字典 dict[@"Params"]  里对应的数组参数（web端传给我们的），这个数组第0个元素是订单号，第1个元素是 charge ，然后使用订单号 和 charge 来调用 ping＋＋  实现支付（其实是用ping＋＋只需要 charge 这一个参数就够了）
            [self payWithDict:dict];
            
#pragma mark --   返回上一页 [self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"]不能再执行时就会返回 toBack
        }else if ([dict[@"action"] isEqualToString:@"toBack"]){
            if (self.isSingle == YES) {//单品列表
                if (![self.webView canGoBack]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{//拼团放送列表
                [self.webView goBack];

            }
        }
        return NO;
        
    }else if([request.URL.query rangeOfString:@"mobile=true"].location == NSNotFound){//分享出去 ，显示导航栏
        NSString *str = request.URL.absoluteString;
        str = [str stringByAppendingString:@"&mobile=true"];
        //self.urlstr = str;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        return NO;
    }else if ([requestString rangeOfString:@"imagePath"].location == NSNotFound) {//没有图片，拼接图片路径
        
        NSString *str = request.URL.absoluteString;
        str = [str stringByAppendingString:[NSString stringWithFormat:@"&imagePath=%@",_imageUrl]];
        //self.urlstr = str;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
        return NO;
    }else{  //
        NSString *str = request.URL.absoluteString;
        if([str rangeOfString:@"mobile=true"].location != NSNotFound){
            str = [str stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
        }
        NSRange range = [str rangeOfString:@"imagePath="];
        NSString *urlString = [str substringFromIndex:range.location + range.length];
        _imageUrl = urlString;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        SMLog(@"_imageUrl = %@---image = %@",_imageUrl,_image);
        self.image = [image scaleToSize:CGSizeMake(60, 60)];
    }
    
    if ([request.URL.absoluteString rangeOfString:@"pingxx.com"].location != NSNotFound) { //web端那边更新ping＋＋后出现重复加载ping＋＋ 页面的情况，这里通过域名做一个拦截
        SMLog(@" 正在加载  pingxx.com   相关域名   直接返回");
        
        return NO;
    }
    
    self.urlstr = request.URL.absoluteString;
    return YES;
}


- (void)payWithDict:(NSDictionary *)dict{
    SMLog(@"payWithDict   dict  %@",dict);
    NSArray *paras = dict[@"params"];
    NSString *orderId = paras[0];
    id charge = paras[1];
    SMLog(@"payWithDict   charge   %@",[charge class]);
    
    [Pingpp createPayment:charge viewController:self appURLScheme:@"unizonepay" withCompletion:^(NSString *result, PingppError *error) {
        if ([result isEqualToString:@"success"]) {  //支付成功
            SMSuccessOrFailViewController * success = [SMSuccessOrFailViewController new];
            success.orderString = orderId;
//            if (indexPath.row == 0) {
//                success.payWay = @"支付宝";
//            }else if (indexPath.row == 1){
//                success.payWay = @"微信";
//            }
            [self.navigationController pushViewController:success animated:YES];
        }else{  //支付失败
            SMLog(@"Error: code=%zd msg=%@  error %@", error.code, [error getMsg],error);
            
            if ([[error getMsg] isEqualToString:@"用户取消操作"]) {
                //是否添加提醒...
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
    }];

}

- (void)callOpenIdAndGiveItToWeb:(UIWebView *)webView{
    #pragma mark -- 这里实现思路：  先截取指令 getOpenId ，然后 调用JS getOpenIdSuccess('微信openid')方法  把自己的微信openId 传过去， 所以这里需要先进行微信登陆
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:KOpenID];
    if (openId) { //已经使用微信登陆过
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KWeChatToken];
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSString *textJS = [NSString stringWithFormat:@"getOpenIdSuccess('%@','%@')",openId,token];
        //                NSString *textJS = @"getOpenIdSuccess('微信openid')";
        [context evaluateScript:textJS];
    }else{  //还没使用微信登陆  ，这里使用微信登陆
        if (![WXApi  isWXAppInstalled]) {  //登陆前先判断用户有没有安装微信 ,如果没有安装微信
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信，无法进行支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{ //已经安装过微信  就调用微信登陆
            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
//                 SMLog(@"user = %@",user);
//                 SMLog(@"user.rawData = %@",user.rawData);
//                 SMLog(@"user.credential = %@",user.credential);
//                 SMLog(@"user.credential.token = %@ user.credential.secret = %@",user.credential.token,user.credential.secret);
//                 SMLog(@"user.credential.rawData = %@",user.credential.rawData);
                 
                 if (state == SSDKResponseStateSuccess)
                 {
                     
                     NSString *openId2 = user.credential.rawData[@"openid"];
                     //将登陆成功后获取到的微信openId 存到本地  方便下次进来时做判断
                     [[NSUserDefaults standardUserDefaults] setObject:openId2 forKey:KOpenID];
                     NSString *token = user.credential.token;
                     [[NSUserDefaults standardUserDefaults] setObject:token forKey:KWeChatToken];
                     JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                     NSString *textJS = [NSString stringWithFormat:@"getOpenIdSuccess('%@','%@')",openId2,token];
                     //                NSString *textJS = @"getOpenIdSuccess('微信openid')";
                     [context evaluateScript:textJS];
                 }
                 else
                 {
                     SMLog(@"%@",error);
                 }
             }];
            
        }
    }

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //self.urlstr = webView.request.URL.absoluteString;
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = [NSString stringWithFormat:@"$('.bottom_fixed_bar,.backbtn,.headerbar,#groupList').hide();"];
//    [context evaluateScript:textJS];

    SMLog(@"[webView canGoBack] = %d",[webView canGoBack]);
}

//禁止webview左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x>0 || point.x<0) {
        [scrollView setContentOffset:CGPointMake(0, point.y)];
    }
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
    
    [self removeCheatView3];

    NSDate *localeDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SMLog(@"timeSp :%@",timeSp); //时间戳的值
    
    //取出照片：
//    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
//    UIImage* image = [UIImage imageWithData:imageData];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
//    UIImage *image = [UIImage imageWithData:data];
    SMLog(@"_imageUrl = %@---image = %@",_imageUrl,_image);
//    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
    NSArray* imageArray = @[self.image];
//    UIImage *newImage = [self scaleToSize:self.image size:CGSizeMake(100, 100)];
//    NSArray* imageArray = @[newImage];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *para = [NSString stringWithFormat:@"&salenumber=%@&salecompany=%@&mode=1&share=1&uid=%@",userID,companyId,userID];
    NSString *urlChang5 = nil;//self.urlstr;
    urlChang5 = [NSString stringWithFormat:@"%@%@",self.urlstr,para];
    SMLog(@"-------%@",urlChang5);

    urlChang5 = [urlChang5 stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
    if (type == 24) {  //分享到QQ  截取掉前面的http://
        urlChang5 = [urlChang5 substringFromIndex:7];
    }
    /*
    if (type == 22) { //分享到微信好友
        NSString *urlChang1 = [urlChang5 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        
        urlChang5 = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:urlChang5 andMoreinfo:NO];
    }
    */
    
    SMLog(@"urlChang5  createOauthUrlForCode = %@",urlChang5);
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





@end
