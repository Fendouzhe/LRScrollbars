//
//  SMNewProductDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewProductDetailController.h"
#import "SMShoppingCartController.h"
#import "SMConfirmPaymentController.h"
#import "SMShippingController.h"
#import "SMCheatView.h"
#import "SMShareMenu.h"
#import "SMNetworkViewController.h"
#import "SMNewProductDetaiCell.h"
#import "SMNewProductDetailSureCell.h"
#import "SMPayViewController.h"
#import "SMShareTypeView.h"


#define KCellHeight 44 *SMMatchHeight

@interface SMNewProductDetailController ()<UIWebViewDelegate,SMShareMenuDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)UIWebView *webView;/**< <#注释#> */

@property (nonatomic ,strong)UIView *cheatView;/**< 上下架萌版 */
//分享菜单的萌版
@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;/**< <#注释#> */

@property (nonatomic ,strong)NSDictionary *dictJson;/**< <#注释#> */

@property (nonatomic ,copy)NSString *baseUrl;/**< <#注释#> */

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *favArray;/**< Favorites   货架个数*/

@property (nonatomic ,assign)NSInteger type; /**< 上下架  1上架   2下架 */

@property (nonatomic ,strong)UIAlertView *noStorages;/**< <#注释#> */

@property (nonatomic ,assign)NSInteger shareType; /**< 1分享链接  2分享二维码  3取消 */

@property (nonatomic ,strong)SMShareTypeView *shareTypeMenu;/**< 选择分享链接还是分享二维码的menu */

@property (nonatomic ,strong)UIWindow *window;/**< <#注释#> */

@end

@implementation SMNewProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.delegate = self;
    //self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    NSString *pId;
    if (self.product) {
        pId = self.product.id;
    }else{
        pId = self.productId;
    }
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@SimpleProductDetail.html",SKAPI_PREFIX_SHARE];
    
    int randomNum = arc4random_uniform(1000000);
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *urlStr = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"?pid=%@&t=%zd&sid=%@&mobileMode=%zd&mobile=true",pId,randomNum,userId,self.mode]];
    self.baseUrl = urlStr;
    SMLog(@"urlStr   %@",urlStr);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.favArray.count) {  // 最后一个确定按钮
        SMNewProductDetailSureCell *cell = [SMNewProductDetailSureCell cellWithTableView:tableView];
        return cell;
    }else{
        SMNewProductDetaiCell *cell = [SMNewProductDetaiCell cellWithTabelView:tableView];
        Favorites *fav = self.favArray[indexPath.row];
        cell.fav = fav;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.favArray.count) {  //点击确定
        if (self.type == 1) { //  上架
            
            [self addToStorage];
            
        }else if (self.type == 2){  //下架
            
            [self removeDown];
        }
    }else{  //点击cell
        SMNewProductDetaiCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.gouBtn.selected = !cell.gouBtn.selected;
        cell.fav.gouIsSelected = !cell.fav.gouIsSelected;
    }
}

- (void)removeDown{
    NSDictionary *paraDict = [self.dictJson[@"params"] firstObject];
    
    NSMutableArray *arrRemove = [NSMutableArray array];
    for (Favorites *f in self.favArray) {
        if (f.gouIsSelected) {
            [arrRemove addObject:f.id];
        }
    }
    
    [self cheatViewTap];
    [[SKAPI shared] removeItem:paraDict[@"id"] fromMyStorage:arrRemove andType:0 block:^(id result, NSError *error) {
        if (!error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [MBProgressHUD showSuccess:@"下架成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshShelfProducts object:self];
            //刷新柜台管理
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCounterDataNotification object:self];
            
        }else{
            SMShowErrorNet;
        }
    }];

}

- (void)addToStorage{
    NSMutableArray *arrStorages = [NSMutableArray array];
    for (Favorites *f in self.favArray) {
        if (f.gouIsSelected) {  //处于选中状态的商品
            [arrStorages addObject:f.id];
        }
    }
    [self cheatViewTap];
    NSDictionary *paraDict = [self.dictJson[@"params"] firstObject];
    [[SKAPI shared] addItem:paraDict[@"id"] toMyStorage:arrStorages andType:0 block:^(id result, NSError *error) {
        if (!error) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [MBProgressHUD showSuccess:@"上架成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshShelfProducts object:self];
            //刷新柜台管理
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCounterDataNotification object:self];
        }else{
            SMShowErrorNet;
            SMLog(@"error addItem  %@   id  %@   arrStorages  %@",error,paraDict[@"id"],arrStorages );
        }
    }];

}

#pragma mark --  shouldStartLoadWithRequest
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SMLog(@"shouldStartLoadWithRequest     %@",request.URL.absoluteString);

    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    SMLog(@"components   ===   %@",components);
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {

        NSString *str = [requestString substringFromIndex:3]; //剪掉前面的  "sk:"
        NSString *dictStr = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dict = [self dictionaryWithJsonString:dictStr];
        self.dictJson = dict;
        SMLog(@"dict====>>%@",dict);
        
        /*
         toBack:"toBack",//返回指令
         toCart:"toCart",//跳转至购物车
         addToCart:"addToCart",//添加至购物车
         buyNow:"buyNow",//立即购买
         removeForStorage:"removeForStorage",//下架微柜台
         addToStorage:"addToStorage",//上架微柜台
         toShare:"toShare",//分享当前页面
         getDianxinTokens:"getDianxinTokens"//获取电信入网资料图片Token
         */
        
        if ([dict[@"action"] isEqualToString:@"toBack"]) {  //返回指令
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([dict[@"action"] isEqualToString:@"toCart"]){   //跳转至购物车
            SMShoppingCartController *vc = [SMShoppingCartController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([dict[@"action"] isEqualToString:@"addToCart"]){  //加入购物车
            
            [self addToCartWithDict:dict];
            
        }else if ([dict[@"action"] isEqualToString:@"buyNow"]){   //立即购买
            [self buyNowWithDict:dict];
        }else if ([dict[@"action"] isEqualToString:@"addToStorage"]){ //上架微柜台
            [self addToStorageWithDict:dict];
        }else if ([dict[@"action"] isEqualToString:@"removeForStorage"]){  //下架微柜台
            [self removeFromeStorage];
        }else if ([dict[@"action"] isEqualToString:@"toShare"]){  //分享当前页面
            [self addShareMemu];
        }else if ([dict[@"action"] isEqualToString:@"getDianxinTokens"]){ //获取电信入网资料图片Token
            SMNetworkViewController *vc = [[SMNetworkViewController alloc] init];
            vc.isDianxin = YES;
            NSDictionary *paraDict = [dict[@"params"] firstObject];
            
            vc.specId = paraDict[@"id"];
            vc.phoneNum = paraDict[@"phone"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([dict[@"action"] isEqualToString:@"payNowBySn"]){   //旅游产品购买
            NSDictionary *paraDict = [dict[@"params"] firstObject];
            NSString *sn = paraDict[@"sn"];
            
            SMPayViewController *vc = [SMPayViewController new];
            vc.orderStr = sn;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        return NO;
    }else if ([request.URL.absoluteString rangeOfString:@"pingxx.com"].location != NSNotFound) { //web端那边更新ping＋＋后出现重复加载ping＋＋ 页面的情况，这里通过域名做一个拦截
        SMLog(@" 正在加载  pingxx.com   相关域名   直接返回");
        
        return NO;
    }else if([request.URL.query rangeOfString:@"mobile=true"].location == NSNotFound){
        NSString *str = request.URL.absoluteString;
        
        str = [str stringByAppendingString:@"&mobile=true"];
        //self.urlstr = str;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        return NO;
    }
    return YES;
}
//禁止webview左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x>0 || point.x<0) {
        [scrollView setContentOffset:CGPointMake(0, point.y)];
    }
}

- (void)removeFromeStorage{
    self.type = 2;   //标记是在下架
    
    NSDictionary *paraDict = [self.dictJson[@"params"] firstObject];
    
    //反查该商品在哪些模板上
    [[SKAPI shared] queryStorageByItem:paraDict[@"id"] block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            [self.favArray removeAllObjects];
            if (array.count > 0) {
                for (Favorites *f in array) {
                    [self.favArray addObject:f];
                }
            }
            
            SMLog(@"self.favArray  queryStorageByItem   %@   id  %@   array  %@",self.favArray,paraDict[@"id"],array);
            
            if (self.favArray.count > 0) {  // 重新创建tableView
                [self creatTableView];
            }
            
            [self changeTabelViewHeight];
            
            [self.tableView reloadData];
            
//
        }else{
            SMShowErrorNet;
        }
    }];
}


- (void)addToStorageWithDict:(NSDictionary *)dict{
    
    self.type = 1;
    
    [self creatTableView];
    
    [self getStoragesWith:dict];
}

- (void)creatTableView{
    //萌版
    self.cheatView = [[UIView alloc] init];
    [self.view addSubview:self.cheatView];
    self.cheatView.backgroundColor = [UIColor blackColor];
    self.cheatView.alpha = 0.4;
    self.cheatView.frame = self.view.bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
    [self.cheatView addGestureRecognizer:tap];
    
    
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 20, KScreenWidth, KCellHeight *6) style:UITableViewStylePlain];
    self.tableView.separatorColor = KGrayColorSeparatorLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //上移动画
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, KScreenHeight - KCellHeight *5, KScreenWidth, KCellHeight *5);
    }];
}

- (void)cheatViewTap{
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KCellHeight *5);
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self.cheatView removeFromSuperview];
        self.cheatView = nil;
    }];
}

- (void)getStoragesWith:(NSDictionary *)dict{
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        if (!error) {
            
            SMLog(@"array = queryStorage    %@",array);
            [self.favArray removeAllObjects];
            for (Favorites * fav in array) {
                if (fav.products.integerValue < 5) {  //已有产品数小于5  才添加
                    [self.favArray addObject:fav];
                }
               
                
            }
            
            [self CounterCheckUPWithDict:dict];
        }else{
            SMShowErrorNet;
        }
    }];
}

// 反查
- (void)CounterCheckUPWithDict:(NSDictionary *)dict{
    
    NSDictionary *paraDict = [dict[@"params"] firstObject];
    
    [[SKAPI shared] queryStorageByItem:paraDict[@"id"] block:^(NSArray *array, NSError *error) {
        if (!error) {
            for (Favorites * fav in array) {
                
                for (NSInteger i=0; i<self.favArray.count; i++) {
                    Favorites * addfav = self.favArray[i];
                    if ([fav.id isEqualToString:[addfav id]]) {
                        [self.favArray removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            
            [self.tableView reloadData];
            
            [self changeTabelViewHeight];
        }else{
            SMShowErrorNet;
        }
    }];
}

- (void)changeTabelViewHeight{
    
    CGFloat height = (self.favArray.count + 1) * KCellHeight;
    self.tableView.frame = CGRectMake(0, KScreenHeight - height, KScreenWidth, height);
    
    if (self.favArray.count == 0 && self.type == 1) {  //上架中
        self.noStorages = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此商品已上架至所有货架中，无需再上架" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.noStorages show];
    }else if (self.favArray.count == 0 && self.type == 2){  //下架中
        self.noStorages = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此商品暂未上架至任何货架" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.noStorages show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.noStorages) {
        [self cheatViewTap];
    }
}

- (void)addShareMemu{
    if (self.cheatView2) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    self.window = window;
    UIView *cheatView2 = [[UIView alloc] init];
    self.cheatView2 = cheatView2;
    cheatView2.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCheatView2)];
    [cheatView2 addGestureRecognizer:tap];
    cheatView2.frame = window.bounds;
    
    SMShareMenu *menu = [SMShareMenu shareMenu];
    menu.delegate = self;
    [window addSubview:menu];
    self.menu = menu;
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@300);
        make.height.equalTo(@270);
    }];
    
    // 动画
    cheatView2.alpha = 0;
    menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        menu.transform = CGAffineTransformMakeScale(1, 1);
        cheatView2.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)removeCheatView2{
    
    [self.shareTypeMenu removeFromSuperview];
    self.shareTypeMenu = nil;
    [UIView animateWithDuration:0.35 animations:^{
        self.menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView2.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView2 removeFromSuperview];
        self.cheatView2 = nil;
        [self.menu removeFromSuperview];
        self.menu = nil;
    }];
}

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    } completion:^(BOOL finished) {
        [self.menu removeFromSuperview];
        self.menu = nil;
    }];
    
    self.shareTypeMenu = [SMShareTypeView shareTypeView];
    [self.window addSubview:self.shareTypeMenu];
    [self.shareTypeMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.window.mas_centerX);
        make.centerY.equalTo(self.window.mas_centerY);
        make.width.equalTo(@(150 *SMMatchWidth));
        make.height.equalTo(@(150 *SMMatchHeight));
    }];
    
    __block SMNewProductDetailController *blockSelf = self;

    self.shareTypeMenu.websiteBlock = ^(NSInteger tag){
        SMLog(@"websiteBlock");
        [blockSelf shareActionWithApp:type andShareType:tag];
        [blockSelf removeCheatView2];
        
    };
    
    self.shareTypeMenu.qrcodeBlock = ^(NSInteger tag){
        SMLog(@"qrcodeBlock");
        [blockSelf shareActionWithApp:type andShareType:tag];
        [blockSelf removeCheatView2];
    };
    
    self.shareTypeMenu.cancelBlock = ^(NSInteger tag){
        SMLog(@"qrcodeBlock");
        [blockSelf removeCheatView2];
    };
 
}

- (void)shareActionWithApp:(SSDKPlatformType)type1 andShareType:(NSInteger)type2{
    
    if (type2 == 2) {   //分享二维码
        NSDate *localeDate = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        //    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
        //    //拿到第一张图片地址
        //    NSString *imageStr = arrStrs[0];
        //    NSString *imageStr2 = [imageStr stringByAppendingString:@"?w=100&h=100&q=30"];
        
        NSDictionary *paraDict = [self.dictJson[@"params"] firstObject];
        NSString *imageStr = [paraDict[@"imagePath"] firstObject];
        NSString *imageStr2 = [imageStr stringByAppendingString:@"?w=100&h=100&q=30"];
        SMLog(@"imageStr2   %@",imageStr2);
        
        
        NSRange range = [self.baseUrl rangeOfString:@"&mobileMode="];
        SMLog(@"self.baseUrl  range   %@",self.baseUrl );
        NSString *urlStr = [self.baseUrl substringToIndex:range.location];
        SMLog(@"urlStr range  %@",urlStr);
        
        //UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:urlStr] withSize:180];
        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:urlStr] withSize:KScreenWidth];
        
//        //缩略图
//        NSData *imgData = UIImageJPEGRepresentation(qrcode, 1.0);
//        // 原始图片
//        UIImage *result = [UIImage imageWithData:imgData];
//        
//        while (imgData.length > 32 *1000) {
//            imgData = UIImageJPEGRepresentation(result, 0.5);
//            result = [UIImage imageWithData:imgData];
//        }
        
        SMLog(@"最终分享出去的url   %@",urlStr);
//        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:qrcode
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupWeChatParamsByText:nil title:nil url:nil thumbImage:result image:qrcode musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台

        
        [ShareSDK share:type1 parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
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
        }];
    }else if (type2 == 1){   //分享链接
        NSDate *localeDate = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        //    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
        //    //拿到第一张图片地址
        //    NSString *imageStr = arrStrs[0];
        //    NSString *imageStr2 = [imageStr stringByAppendingString:@"?w=100&h=100&q=30"];
        
        NSDictionary *paraDict = [self.dictJson[@"params"] firstObject];
        NSString *imageStr = [paraDict[@"imagePath"] firstObject];
        NSString *imageStr2 = [imageStr stringByAppendingString:@"?w=100&h=100&q=30"];
        SMLog(@"imageStr2   %@",imageStr2);
        
        
        NSRange range = [self.baseUrl rangeOfString:@"&mobileMode="];
        SMLog(@"self.baseUrl  range   %@",self.baseUrl );
        NSString *urlStr = [self.baseUrl substringToIndex:range.location];
        SMLog(@"urlStr range  %@",urlStr);
//        
//        NSString *urlChang1 = [urlStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
//        NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
//        NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
//        NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
//        NSString *urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//        SMLog(@"urlChang5   %@",urlChang5);
    
        /*
        if (type1 == 22) { //分享到微信
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            SMLog(@"urlStr   %@",urlStr);
            urlStr = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:urlStr andMoreinfo:NO];
        }
         */
        
//        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:urlStr] withSize:180];
//        
//        //缩略图
//        NSData *imgData = UIImageJPEGRepresentation(qrcode, 1.0);
//        // 原始图片
//        UIImage *result = [UIImage imageWithData:imgData];
//        
//        while (imgData.length > 32 *1000) {
//            imgData = UIImageJPEGRepresentation(result, 0.5);
//            result = [UIImage imageWithData:imgData];
//        }
        
        SMLog(@"最终分享出去的url   %@",urlStr);
        //        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:paraDict[@"desc"]
                                         images:imageStr2
                                            url:[NSURL URLWithString:urlStr]
                                          title:paraDict[@"name"]
                                           type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupWeChatParamsByText:paraDict[@"desc"] title:paraDict[@"name"] url:[NSURL URLWithString:@"urlStr"] thumbImage:result image:qrcode musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        

        [ShareSDK share:type1 parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
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
        }];

        
    }
}




//取消分享
- (void)cancelBtnDidClick{
    [self removeCheatView2];
}
#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)buyNowWithDict:(NSDictionary *)dict{
    NSString * nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
    NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
    NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
    NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
    
    addressModle * modle = [addressModle new];
    modle.name = nameStr;
    modle.phone = phoneStr;
    modle.address = [NSString stringWithFormat:@"%@%@",provinceStr,detailAddress];
    
    //产品cart
    Cart * cart = [Cart new];
    if (self.product) {
        cart.id = self.product.id;
    }else{
        cart.id = self.productId;
    }
    
    NSDictionary *paraDict = [dict[@"params"] firstObject];
    
    cart.amount = [paraDict[@"amount"] integerValue];
    cart.productId = paraDict[@"id"];
    cart.productName = paraDict[@"name"];
    cart.productPrice = paraDict[@"price"];
    cart.productFinalPrice = dict[@"finalPrice"];
    cart.imagePath = [paraDict[@"image"] firstObject];
    cart.shippingFee = paraDict[@"shipping"];
    cart.isSelect = YES;
    
    if (nameStr && phoneStr && provinceStr && detailAddress) { //如果已经填写过收货地址信息
#pragma mark -- 为了修改立即购买的bug  这里先加入购物车  再跳转购买界面测试
        //直接跳转到购买界面

        SMLog(@"如果已经选择过商品规格了 ");
        
        [[SKAPI shared] putCartByProductId:paraDict[@"id"] andAmount:1 block:^(id result, NSError *error) {
            if (!error) {
                //添加成功
                SMLog(@"putCartByProductId  result  %@",result);
                //                SMShoppingCartController *vc = [[SMShoppingCartController alloc] init];
                //
                //                [self.navigationController pushViewController:vc animated:YES];
                //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                    [alert show];
                
                
                SMConfirmPaymentController * confirm = [[SMConfirmPaymentController alloc]init];
                confirm.isPushedByBuyNew = YES;
                confirm.address = modle;
                [confirm.cartArray addObject:cart];
                
//                SMLog(@"self.upView.topView.priceLabel.text   %@",self.upView.topView.priceLabel.text);
                confirm.specPrice = paraDict[@"finalPrice"];
                SMLog(@"confirm.specPrice  %@",paraDict[@"finalPrice"]);
                confirm.specName = paraDict[@"sku"];
                [self.navigationController pushViewController:confirm animated:YES];
                
            }else{
                //添加失败
                SMLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }else{ //还没填写收货地址信息，跳转到填写地址信息界面
        
        SMShippingController * shipping = [[SMShippingController alloc]init];
        shipping.isPushedByBuyNew = YES;
        [shipping.cartArray addObject:cart];
        shipping.specPrice = paraDict[@"finalPrice"];
        SMLog(@"shipping.specPrice   %@   dict   %@",shipping.specPrice,dict);
        shipping.specName = paraDict[@"sku"];
        [self.navigationController pushViewController:shipping animated:YES];
    }
    
}

- (void)addToCartWithDict:(NSDictionary *)dict{
    NSDictionary *paraDict = [dict[@"params"] firstObject];
    NSString *productId = paraDict[@"id"];
    [[SKAPI shared] putCartByProductId:productId andAmount:1 block:^(id result, NSError *error) {
        if (!error) {
            //添加成功
            SMLog(@"putCartByProductId  result  %@",result);
            
//            SMConfirmPaymentController * confirm = [[SMConfirmPaymentController alloc]init];
//            //cart.shippingFee  = self.product.ship
//            confirm.address = modle;
//            [confirm.cartArray addObject:cart];
//            
//            SMLog(@"self.upView.topView.priceLabel.text   %@",self.upView.topView.priceLabel.text);
//            confirm.specPrice = self.specPrice2;
//            confirm.specName = self.specName;
//            [self.navigationController pushViewController:confirm animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功加入购物车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            //添加失败
            SMLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车失败，请重新添加." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

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


#pragma mark -- 懒加载
- (NSMutableArray *)favArray{
    if (_favArray == nil) {
        _favArray = [NSMutableArray array];
    }
    return _favArray;
}


@end
