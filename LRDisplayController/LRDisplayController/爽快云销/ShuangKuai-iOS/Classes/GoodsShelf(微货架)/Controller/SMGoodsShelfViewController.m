//
//  SMGoodsShelfViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

//这一页注释的部分比较多，是以后可能会用戴的页面

#import "SMGoodsShelfViewController.h"
#import "SMLeftItemBtn.h"
#import "SMSearchBar.h"
#import "SMScanerBtn.h"
#import "SMShelfTopView.h"
#import "SMScannerViewController.h"
#import "SMPersonCenterViewController.h"
#import "SMPersonCenterViewController.h"
#import <MBProgressHUD.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SMPayViewController.h"
#import "LocalFavorites.h"
#import "SMShelfTemplateViewController.h"
#import "AppDelegate.h"


#define KPikerVIewHeight 200
//#define KWebString @"http://192.168.1.44/sk/sk_sales.html"
//#define KWebString @"http://120.25.85.236:1224/shuangkuai_app/sk_sales.html"

#define KWebString @"http://www.shuangkuai.co:1224/shuangkuai_app/sk_sales.html"



@interface SMGoodsShelfViewController ()<UIWebViewDelegate,MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>

//@property (nonatomic ,strong)SMSearchBar *searchBar;
//
//@property (nonatomic ,strong)UIWebView *webViewShelf;
//
//@property (nonatomic ,strong)UIWebView *webViewPopularize;
//
//@property (nonatomic ,strong)SMShelfTopView *shelfTopView;

@property (nonatomic ,strong)UIWebView *webView;

@property (nonatomic ,strong)MBProgressHUD *HUD;

//webView当前加载的url
@property (strong,nonatomic)NSString *currentURL;
//webView当前加载的url 的title
@property (strong,nonatomic)NSString *currentTitle;
/**
 *  选择几号微货架
 */
@property (nonatomic ,strong)UIPickerView *pickerView;
/**
 *  出现选择微货架时的蒙板
 */
@property (nonatomic ,strong)UIView *bgGrayView;

@property (nonatomic ,strong)NSMutableArray *arrPickerSouce;
/**
 *  确定
 */
@property (nonatomic ,strong)UIButton *sureBtn;

@property (nonatomic ,assign)NSInteger count;

@end

@implementation SMGoodsShelfViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //在这里面加着两行代码，是为了解决一个电池栏的BUG ，如果删除下面两行会出BUG
    [self.view addSubview:self.HUD];
    
    [self setupWebView];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

#pragma mark -- 懒加载
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.bounces=NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (MBProgressHUD *)HUD{
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HUD.delegate = self;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setupNav];
    
    //设置我的微货架，我的微推广的那一排View
    //    [self setupTopView];
    
    //    [self setupWebView];
//    [self clearWebViewCache];
    
    [self.view addSubview:self.HUD];
    
    //[self setupWebView];
    
    self.view.backgroundColor = KBatteryBarColor;
    
    
}

- (void)setupWebView{
    [self.view addSubview:self.webView];
    //    self.webView.backgroundColor = [UIColor yellowColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
    }];
    
    
    //NSURL *url = [NSURL URLWithString:KWebString];
    
    
    NSArray * array = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (array.count==0) {
        [self requestShelfData];
    }else
    {
        NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
        
        Favorites * fav = array[row];
        
        NSString *para = [NSString stringWithFormat:@"?favId=%@&mode=1",fav.id];
        
        NSString * urlRequest = [KWebString stringByAppendingString:para];
        
        NSURL *url = [NSURL URLWithString:urlRequest];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)clearWebViewCache{
    //清除webView上的所有缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/**
 *  点击了扫描二维码
 */
- (void)scanerBtnDidClick{
    //    [self.searchBar resignFirstResponder];
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}


#pragma mark -- UIWebViewDelegate    iOS 与 JS 交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"sk"]) {
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"pageBack"]){
            // 返回页面
            SMLog(@"执行返回代码");
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"sharePage"]){
            SMLog(@"执行分享代码");
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
            self.currentURL = webView.request.URL.absoluteString;
            SMLog(@"title-%@--url-%@--",self.title,self.currentURL);
            
            [self sharePage];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"addToPromo"]){
            
            SMLog(@"执行 添加到微推广代码");
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"openQrcode"]){
            SMLog(@"执行 二维码扫描 代码");
            SMScannerViewController *vc = [[SMScannerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"personalCenter"]){
            SMLog(@"点击了 头像按钮  跳到个人中心");
            SMPersonCenterViewController *vc = [[SMPersonCenterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([(NSString *)[components objectAtIndex:1] isEqualToString:@"payOrder"]){
            
            NSString *para = (NSString *)[components lastObject];
            SMLog(@"跳转 支付页面   订单：%@",para);
            SMPayViewController *vc = [[SMPayViewController alloc] init];
            vc.orderStr = para;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"changeTemplate"]){
            SMLog(@"点击了 切换模版");
            [self showPickerView];
            
        }
        return NO;
    }
    return YES;
}

- (void)showPickerView{
    self.count = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentShelfCount];
    [self.arrPickerSouce removeAllObjects];
    SMLog(@"self.count    %zd",self.count);
    NSArray * array = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
   
    for (NSInteger i = 0; i < array.count; i++) {
        LocalFavorites * fav = array[i];
        NSString *title = fav.name;
        [self.arrPickerSouce addObject:title];
    }
    
    [self.pickerView reloadAllComponents];
    //蒙板
    UIView *bgView = [[UIView alloc] init];
    self.bgGrayView = bgView;
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTabBarHeight);
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap)];
    [bgView addGestureRecognizer:tap];
    
    //加入pickerview
    [self.view addSubview:self.pickerView];
    
    //确定按钮
    UIButton *sureBtn = [[UIButton alloc] init];
    self.sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    CGFloat sureBtnH = 20;
    sureBtn.frame = CGRectMake(0, KScreenHeight - KTabBarHeight - KPikerVIewHeight - sureBtnH + 20, KScreenWidth, sureBtnH);
    [sureBtn setBackgroundColor:[UIColor whiteColor]];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sureBtnClick{
    SMLog(@"点击了 确定");
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    //SMLog(@"%zd",row + 1);
    
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:KCurrentSelectedShelf];
    
    NSArray * array = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    LocalFavorites * fav = array[row];
    NSString *para = [NSString stringWithFormat:@"?favId=%@&mode=1",fav.id];
    NSString *webStr = KWebString;
    NSString *loadStr = [webStr stringByAppendingString:para];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]];
    [self.webView loadRequest:request];
}

- (void)bgViewTap{
    [self.bgGrayView removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

/**
 *  分享页面
 */
- (void)sharePage{
    NSArray* imageArray = @[[UIImage imageNamed:@"爽快图标120"]];
    NSString *headStr = [[self.currentURL componentsSeparatedByString:@"&"] firstObject];
    SMLog(@"headStr   %@",headStr);
    NSString *urlStr = [headStr stringByAppendingString:@"&mode=0"];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"很不错的宝贝，快打开看看！"
                                         images:imageArray
                                            url:[NSURL URLWithString:urlStr]
                                          title:@"这个宝贝太棒了！"
                                           type:SSDKContentTypeAuto];
        SMLog(@"self.currentURL   %@",self.currentURL);
        SMLog(@"urlStr   %@",urlStr);
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
         ];}
}

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource
//显示几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//显示几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrPickerSouce.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.arrPickerSouce[row];
}



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


#pragma mark --    懒加载
- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight - KTabBarHeight - KPikerVIewHeight + 20, KScreenWidth, KPikerVIewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (NSMutableArray *)arrPickerSouce{
    if (_arrPickerSouce == nil) {
        _arrPickerSouce = [NSMutableArray array];
    }
    return _arrPickerSouce;
}

//微货架的数据
-(void)requestShelfData{
    //    [self.arrShelfs removeAllObjects];
    
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        
        if (!error) {
            SMLog(@"array  %@",array);
        
            if (array.count>0) {
                
                [[NSUserDefaults standardUserDefaults] setInteger:array.count forKey:KCurrentShelfCount];
                
                NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
                
                Favorites * fav = array[row];
                
                NSString *para = [NSString stringWithFormat:@"?favId=%@&mode=1",fav.id];
                
                NSString * urlRequest = [KWebString stringByAppendingString:para];
                
                NSURL *url = [NSURL URLWithString:urlRequest];
                
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
                
                //保存下来
                [self saveSqliteWith:array];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有微柜台,请到工作台->柜台管理添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alertView show];
            }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}

-(void)saveSqliteWith:(NSArray *)array
{
    //保存前需要删除
    NSArray * localArray = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (LocalFavorites * fav in localArray) {
            [fav MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    
    //    存起来
#warning 存储数据  乱序   换到主线程存就没有问题了
    //这里数组  存储时候  乱序了
    for (Favorites * favorites in array) {
        SMLog(@"name = %@",favorites.name);
        LocalFavorites * localFavorites = [LocalFavorites MR_createEntity];
        localFavorites.id = favorites.id;
        localFavorites.createAt = [NSNumber numberWithInteger:favorites.createAt];
        localFavorites.name = favorites.name;
        localFavorites.type = [NSNumber numberWithInteger:favorites.type];
        localFavorites.products = favorites.products;
        localFavorites.activitys = [NSNumber numberWithInteger:favorites.activitys];
        localFavorites.coupons = [NSNumber numberWithInteger:favorites.coupons];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        SMShelfTemplateViewController * shelf = [SMShelfTemplateViewController new];
//        [self.navigationController pushViewController:shelf animated:YES];
        
    }else{
        
    }
}

@end
