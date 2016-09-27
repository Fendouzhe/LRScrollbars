//
//  SMActiveWebVc.m
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/7/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMActiveWebVc.h"
#import "SMShareToWXMenu.h"
#import <ShareSDK/ShareSDK.h>
#import "SMNewFav.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SMShareMenu.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <Pingpp.h>
#import "SMSuccessOrFailViewController.h"
#import <Pingpp.h>
#import "SVProgressHUD.h"

@interface SMActiveWebVc ()<UIWebViewDelegate,SMShareMenuDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong)UIWebView *webView;/**< <#注释#> */

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;


@property(nonatomic,copy)NSString *urlstr;

@property(nonatomic,strong)UIImage *image;

@end

@implementation SMActiveWebVc

- (void)loadView{
    self.view = [[UIWebView alloc] init];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //清理UIWebView缓存
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}
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
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fenxiangRed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    //self.view.backgroundColor = KControllerBackGroundColor;
    self.webView = (UIWebView *)self.view;
    //[self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.scrollView.delegate = self;
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@sk_promotion.html",SKAPI_PREFIX_SHARE];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    //NSString *para = [NSString stringWithFormat:@"?uid=%@&pid=%@&share=1&mobile=true",userID,self.pId];
    NSString *para = [NSString stringWithFormat:@"?uid=%@&pid=%@&mobile=true&mode=1",userID,self.pId];
    
    NSString *loadStr = [baseUrl stringByAppendingString:para];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
    
    //SMLog(@"loadStr  %@----self.pId = %@",loadStr,self.pId);
    
    [self setupLeftItem];
    
    //移除分页指示器新消息动画动画
    [[NSNotificationCenter defaultCenter] postNotificationName:PageControlRemoveAnimationNotification object:nil userInfo:@{@"index":KHuoDongYaoQingPage}];
    //移除已读的活动邀请推送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveReadedPushMessageNotification object:nil userInfo:@{@"type":@(KHuoDongYaoQing_73)}];
    //移除滚动标题栏活动邀请消息红点
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTitleScrollViewTitleBageNotification object:nil userInfo:@{@"index":@(KNewHuoDongYaoQingPage)}];
}
- (void)setupLeftItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
}




- (void)setupShareBtn{
    UIButton *buttpon = [[UIButton alloc] init];
    [buttpon setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [buttpon addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    //    [buttpon sizeToFit];
    buttpon.size = ScaleToSize;
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttpon];
}
#pragma mark -- 点击事件
- (void)share{
    
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

- (void)leftItemClick{

//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    //[self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"];
    
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = [NSString stringWithFormat:@"toBack()"];
//    [context evaluateScript:textJS];
//    NSLog(@"[context evaluateScript:textJS]  = %@",[context evaluateScript:textJS]);
    //NSLog(@"[context evaluateScript:textJS]  = %@",[self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"]);
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString:@"toBack()"];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SMLog(@"request.URL.absoluteString   %@",request.URL.absoluteString);
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    SMLog(@"components===%@",components);
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
        //if ([request.URL.absoluteString rangeOfString:@"_list"].location != NSNotFound ) {
        NSString *str = [requestString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        SMLog(@"dictStr  dictionaryWithJsonString  %@ ",dictStr);
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        
        SMLog(@"活动邀请dict == %@",dict);
        
        //self.posterTitle = dict[@"params"];
        if ([dict[@"action"] isEqualToString:@"share_detail"]) {  //导航栏显示 分享按钮
            [self setupShareBtn];
        }
        if ([dict[@"action"] isEqualToString:@"titleName"]) {  //传参数  公司id userid 传给网页端
            self.title = dict[@"params"][0];
        }else if ([dict[@"action"] isEqualToString:@"getOpenId"]){  //把openid 传给web  支付需要的
#pragma mark -- 这里实现思路：  先截取指令 getOpenId ，然后 调用JS getOpenIdSuccess('微信openid')方法  把自己的微信openId 传过去， 所以这里需要先进行微信登陆
            [self callOpenIdAndGiveItToWeb:webView];
            
        }else if ([dict[@"action"] isEqualToString:@"createPayment"]){ //  创建支付
#pragma mark -- 这里的实现思路： 先截取到指令 createPayment  然后  拿到字典 dict[@"Params"]  里对应的数组参数（web端传给我们的），这个数组第0个元素是订单号，第1个元素是 charge ，然后使用订单号 和 charge 来调用 ping＋＋  实现支付（其实是用ping＋＋只需要 charge 这一个参数就够了）
            [self payWithDict:dict];
            
        }else if ([dict[@"action"] isEqualToString:@"payNowBySn"]){ //  创建支付
            NSArray *arrPara = dict[@"params"];
            NSString *orderId = arrPara.firstObject;
            NSString *type = arrPara[1];
            [self buyNowWithOrderId:orderId andType:type];
        }else if ([dict[@"action"] isEqualToString:@"generateEventQrcode"]){ //  创建支付
            UIImage *image = [self getImage];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }else if ([dict[@"action"] isEqualToString:@"toBack"]){ //  返回上一页
            if (![webView canGoBack]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        return NO;
        
    }else if([request.URL.query rangeOfString:@"mobile=true"].location == NSNotFound){
        NSString *str = request.URL.absoluteString;
        str = [str stringByAppendingString:@"&mobile=true"];
        //self.urlstr = str;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        return NO;
    }else if ([requestString rangeOfString:@"imagePath"].location == NSNotFound) {
        
        NSString *str = request.URL.absoluteString;
        str = [str stringByAppendingString:[NSString stringWithFormat:@"&imagePath=%@",_imageUrl]];
        //self.urlstr = str;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
        return NO;
    }else{
        NSString *str = request.URL.query;
        if([str rangeOfString:@"mobile=true"].location != NSNotFound){
            str = [str stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
        }
        NSRange range = [str rangeOfString:@"imagePath="];
        NSString *urlString = [str substringFromIndex:range.location + range.length];
        _imageUrl = urlString;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        //SMLog(@"_imageUrl = %@---image = %@",_imageUrl,_image);
        self.image = [image scaleToSize:CGSizeMake(60, 60)];//[self scaleToSize:image size:CGSizeMake(60, 60)];

    }
    
    if ([request.URL.absoluteString rangeOfString:@"pingxx.com"].location != NSNotFound) { //web端那边更新ping＋＋后出现重复加载ping＋＋ 页面的情况，这里通过域名做一个拦截
        SMLog(@" 正在加载  pingxx.com   相关域名   直接返回");
        
        return NO;
    }
    
    self.urlstr = request.URL.absoluteString;
    return YES;
}

- (UIImage *)getImage{
    //开启图形上下文
    
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 3.0);
    }else {
        UIGraphicsBeginImageContext(self.view.frame.size);
    }
    
    //    UIGraphicsBeginImageContext(self.view.frame.size);
    //获取图形上下文
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    //作用：就是把View内部图层上的内容 绘制到 上下文当中
    //截取哪块取决于这个View
    [self.view.layer renderInContext:ctx];
    //回去绘制号的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
}

- (void)buyNowWithOrderId:(NSString *)orderId andType:(NSString *)type{
    
    [[SKAPI shared] pingppCharge:orderId andChannel:type block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  pingppCharge  %@",result);
            [Pingpp createPayment:result viewController:self appURLScheme:@"unizonepay" withCompletion:^(NSString *result, PingppError *error) {
                if ([result isEqualToString:@"success"]) {  //支付成功
                    //跳转到支付结果控制器
//                    SMSuccessOrFailViewController * success = [SMSuccessOrFailViewController new];
//                    success.orderString = orderId;
//                    //            if (indexPath.row == 0) {
//                    //                success.payWay = @"支付宝";
//                    //            }else if (indexPath.row == 1){
//                    //                success.payWay = @"微信";
//                    //            }
//                    [self.navigationController pushViewController:success animated:YES];
                    
                    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                    NSString *textJS = [NSString stringWithFormat:@"paySuccess()"];
                    //                NSString *textJS = @"getOpenIdSuccess('微信openid')";
                    [context evaluateScript:textJS];
                    
                }else{  //支付失败
//                    SMLog(@"Error: code=%zd msg=%@  error %@", error.code, [error getMsg],error);
//                    
//                    if ([[error getMsg] isEqualToString:@"用户取消操作"]) {
//                        //是否添加提醒...
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
                    
                    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                    NSString *textJS = [NSString stringWithFormat:@"payFail()"];
                    //                NSString *textJS = @"getOpenIdSuccess('微信openid')";
                    [context evaluateScript:textJS];
                }
                
            }];
        }else{
            SMLog(@"error pingppCharge  %@",error);
        }
    }];
}

//禁止webview左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x>0 || point.x<0) {
        [scrollView setContentOffset:CGPointMake(0, point.y)];
    }
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
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSString *textJS = [NSString stringWithFormat:@"getOpenIdSuccess('%@')",openId];
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
                 if (state == SSDKResponseStateSuccess)
                 {
                     NSString *openId2 = user.credential.rawData[@"openid"];
                     //将登陆成功后获取到的微信openId 存到本地  方便下次进来时做判断
                     [[NSUserDefaults standardUserDefaults] setObject:openId2 forKey:KOpenID];
                     JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
                     NSString *textJS = [NSString stringWithFormat:@"getOpenIdSuccess('%@')",openId2];
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
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = [NSString stringWithFormat:@"$('.bottom_fixed_bar,.backbtn,.headerbar,#groupList').hide();"];
//    [context evaluateScript:textJS];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil){
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    SMLog(@"jsonData  %@",jsonData);
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
//    image = [self scaleToSize:image size:CGSizeMake(100, 100)];
    NSArray* imageArray = @[self.image];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *para = [NSString stringWithFormat:@"&salenumber=%@&pid=%@&salecompany=%@&mode=1&share=1&uid=%@",userID,self.pId,companyId,userID];
    NSString *urlChang5 = [self.urlstr stringByAppendingString:para];
    urlChang5 = [urlChang5 stringByReplacingOccurrencesOfString:@"&mobile=true" withString:@""];
    
    if (type == 24) {  //分享到QQ  截取掉前面的http://
        urlChang5 = [urlChang5 substringFromIndex:7];
    }
    
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


@end
