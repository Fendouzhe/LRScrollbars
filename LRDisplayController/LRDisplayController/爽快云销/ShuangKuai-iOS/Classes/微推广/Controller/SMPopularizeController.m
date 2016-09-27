//
//  SMPopularizeController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPopularizeController.h"
#import "SMLeftItemBtn.h"
#import "SMScanerBtn.h"
#import "SMScannerViewController.h"
#import "SMPersonInfoViewController.h"
#import "SMPosterController.h"
#import "SMArticleController.h"
#import "SMShareToWXMenu.h"
#import "SMNewFav.h"
#import <ShareSDK/ShareSDK.h>




@interface SMPopularizeController ()<SMShareToWXMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *discountView;

@property (weak, nonatomic) IBOutlet UIView *articleVIew;

@property (weak, nonatomic) IBOutlet UIView *postersView;

@property (weak, nonatomic) IBOutlet UIView *storageView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewLeftMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewMarginRight;


@property (nonatomic ,strong)SMLeftItemBtn *leftItemBtn;

@property (nonatomic ,strong)UIView *cheatView;

@property (nonatomic ,strong)SMShareToWXMenu *menu;
@property (nonatomic ,copy)NSString *favID;

@end

@implementation SMPopularizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self match];
    
    //添加点击手势
    [self addGesture];
    
}

- (void)addGesture{
    UITapGestureRecognizer *tapDiscount = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountTap)];
    [self.discountView addGestureRecognizer:tapDiscount];
    
    UITapGestureRecognizer *tapArticle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articleTap)];
    [self.articleVIew addGestureRecognizer:tapArticle];
    
    UITapGestureRecognizer *tapPoster = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterTap)];
    [self.postersView addGestureRecognizer:tapPoster];
    
    UITapGestureRecognizer *tapCounter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(counterTap)];
    [self.storageView addGestureRecognizer:tapCounter];
}


- (void)match{
    self.iconWidth.constant = 80 *SMMatchHeight;
    self.iconHeight.constant = 80 *SMMatchHeight;
    self.bigViewHeight.constant = 300 *SMMatchHeight;
    self.bigViewLeftMargin.constant = 35 *SMMatchWidth;
    self.bigViewMarginRight.constant = 35 *SMMatchWidth;
    
}

- (void)setupNav{
    self.title = @"微推广";
    
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftItemBtn = leftItemBtn;
    CGFloat wh;
    if (isIPhone5) {
        wh = KIconWH;
    }else if (isIPhone6){
        wh = KIconWH *KMatch6;
    }else if (isIPhone6p){
        wh = KIconWH * KMatch6p;
    }
    
    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //二维码
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.leftItemBtn.customImageView.image = image;
    }

}

#pragma mark -- 点击事件

- (void)counterTap{
    SMLog(@"点击了 微柜台推广");
    [self.view addSubview:self.cheatView];
    [self setupMenu];
}

- (void)setupMenu{
    self.menu = [SMShareToWXMenu shareToWXMenu];
    [self.view addSubview:self.menu];
    self.menu.delegate = self;
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.height.equalTo(@60);
    }];
}

#pragma mark -- SMShareToWXMenuDelegate
- (void)wxMenuDidClick{
    SMLog(@"点击了 微信分享");
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@sk_sales.html",SKAPI_PREFIX_SHARE];
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *para = [NSString stringWithFormat:@"?favId=%@&userid=%@",self.favID,userid];
    NSString *endUrlStr = [baseUrl stringByAppendingString:para];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    
    [self getCurrentFavID];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"微柜台推广"
                                     images:image
                                        url:[NSURL URLWithString:endUrlStr]
                                      title:[NSString stringWithFormat:@"%@掌柜",userName]
                                       type:SSDKContentTypeAuto];
    
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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

- (void)getCurrentFavID{

    [[SKAPI shared] queryStorageList:^(id result, NSError *error) {
        if (!error) {
            
            NSArray *arrDatas = [SMNewFav mj_objectArrayWithKeyValuesArray:[result valueForKey:@"favorites"]];
            NSInteger currentShelf = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
            SMNewFav *fav = arrDatas[currentShelf];
            self.favID = fav.favId;
        }else{
            
            SMLog(@"error  queryStorageList  %@ ",error);
        }
    }];
}


- (void)posterTap{
    SMLog(@"点击了 微海报推广");
    SMPosterController *vc = [SMPosterController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)articleTap{
    SMLog(@"点击了 微信文章推广");
    SMArticleController *vc = [SMArticleController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)discountTap{
    SMLog(@"点击了 优惠券推广");
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SlideInFromTop;
    alert.hideAnimationType = SlideOutToBottom;
    
    [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"此功能需要和企业微信公众平台对接开发喔" closeButtonTitle:nil duration:3];
    
    SCLButton *nameBtn = [alert addButton:@"确定" actionBlock:^{
        
    }];
    nameBtn.backgroundColor = KRedColorLight;
}

- (void)scanerBtnDidClick{
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

- (void)leftItemDidClick:(UIButton *)leftBtn{
    SMLog(@"点击了左上角的头像按钮  %@",[leftBtn class]);
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
