//
//  SMShoppingController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShoppingController.h"
#import "SMNewShoppingCell.h"
#import "SMNewShoppingCell1.h"
#import "SMProductCollectionViewCell.h"
#import "SMNewShoppingSequenceCell.h"
#import "SMSequenceView.h"
#import "SMProductDetailController.h"
#import <SDCycleScrollView.h>
#import "SMLeftItemBtn.h"
#import "SMPersonInfoViewController.h"
#import "SMRightItemView.h"
#import "SMSearchViewController.h"
#import "SMScannerViewController.h"
#import "SMProductClassesController.h"
#import "SMProductTool.h"
#import "LocalHotProductTool.h"
#import "SMShareMenu.h"
#import "SMClassesController.h"
#import "SMNewProductDetailController.h"
#import "SMNewPersonInfoController.h"
#import "SMShareTypeView.h"


@interface SMShoppingController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMNewShoppingSequenceCellDelegate,SMSequenceViewDelegate,SDCycleScrollViewDelegate,SMRightItemViewDelegate,SMShareMenuDelegate>

@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic ,strong)NSMutableArray *arrHotProducts;

@property (nonatomic ,strong)NSMutableArray *arrProducts;

@property (nonatomic ,strong)UIButton *priceBtn;

@property (nonatomic ,strong)UIButton *commisionBtn;

@property (nonatomic ,strong)UIButton *salesCountBtn;

@property (nonatomic ,strong)SMSequenceView *sequenceViewLeft;

@property (nonatomic ,strong)SMSequenceView *sequenceViewRight;

@property (nonatomic ,strong)UIView *cheatView;

@property (nonatomic ,strong)UIWindow *window;

@property (nonatomic ,assign)NSInteger page;

@property (nonatomic ,assign)PRODUCT_SORT_TYPE sequenceType;

@property (nonatomic ,strong)NSArray *arrScrollProducts;

@property (nonatomic ,strong)SMLeftItemBtn *leftIconBtn;

@property (nonatomic ,strong)UIView *cheatView2;/**< 萌版 */

@property (nonatomic ,strong)SMShareMenu *menu;/**< 分享菜单 */

@property (nonatomic ,copy)NSString *baseUrl;/**< <#注释#> */

@property (nonatomic ,copy)NSString *paraStr;/**< 分享出去的链接后面需要拼接的字符串 */

@property (nonatomic ,strong)UIButton *productNewBtn;/**< 新品按钮 */

@property (nonatomic ,assign)NSInteger shareType; /**< 1分享链接  2分享二维码  3取消 */

@property (nonatomic ,strong)SMShareTypeView *shareTypeMenu;/**< 选择分享链接还是分享二维码的menu */

@end

@implementation SMShoppingController

static NSString *const section0ReuserIdentifier = @"newShoppingCell";
static NSString *const section1ReuserIdentifier = @"newShoppingSequenceCell";
static NSString *const section2ReuserIdentifier = @"productCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userEngCompanyName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserEngCompanyName];
    if (userEngCompanyName.length) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@商城",userEngCompanyName];//@"微商城";
    }else{
        self.navigationItem.title = @"商城";
    }
    //判断分享出去链接的后面需要拼接什么字符串
    [self judgeSharePath];
    
    [self setupNav];
    
    //注册cell
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[SMNewShoppingCell class] forCellWithReuseIdentifier:section0ReuserIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMNewShoppingSequenceCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:section1ReuserIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMProductCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:section2ReuserIdentifier];
    
    self.window = [[UIApplication sharedApplication].windows lastObject];
    
    //拿到热销商品数据
    [LocalHotProductTool initialize];
    
    NSArray *arr = [LocalHotProductTool queryData:nil];
    SMLog(@"arr.count  LocalHotProductTool  %zd",arr.count);
    
    if (arr.count > 0) {
//        self.arrHotProducts = (NSMutableArray *)arr;
        for (Product *p in arr) {
//            NSArray *arrImagePath = [NSString mj_objectArrayWithKeyValuesArray:p.adImage];
//            [self.arrHotProducts addObject:arrImagePath.firstObject];
//            SMLog(@"p.adImage   %@",p.adImage);
            [self.arrHotProducts addObject:p.adImage];
        }
        [self.collectionView reloadData];
    }else{
        [self getHotProducts];
    }
    
    //拿到普通商品数据
    [SMProductTool initialize];
    SMLog(@"[self lookForDataInLocal].count    %zd",[self lookForDataInLocal].count);
    if ([self lookForDataInLocal].count > 0) {
        self.arrProducts = (NSMutableArray *)[self lookForDataInLocal];
        [self.collectionView reloadData];
        SMLog(@"使用本地数据刷新界面");
    }else{
        self.page = 1;
        self.sequenceType = SortType_Default;
        [self getProductWith:self.sequenceType];
    }
  
    [self SetupMJRefresh];
    [self.collectionView.mj_header beginRefreshing];
    
}

- (void)judgeSharePath{
//        self.baseUrl = @"m.shuangkuai.co/shuangkuai_app/mall.html";
//    [[SKAPI shared] shoppingShareType:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result  shoppingShareType %@",result);
//            NSNumber *num = [[result objectForKey:result] objectForKey:@"template"];
//            if (num.integerValue == 0) {
//                self.paraStr = @"mall_0.html";
//            }else if (num.integerValue == 1){
//                self.paraStr = @"mall_1.html";
//            }else if (num.integerValue == 2){
//                self.paraStr = @"mall_2.html";
//            }
//            self.baseUrl = [KShoppingVcShare stringByAppendingString:self.paraStr];
//        }else{
//            SMLog(@"error shoppingShareType  %@",error);
//        }
//    }];
    
    //self.paraStr = @"sk_mall.html";
    self.paraStr = @"mall.html";
    self.baseUrl = [KShoppingVcShare stringByAppendingString:self.paraStr];
    
}
//查询
- (NSArray *)lookForDataInLocal{
    return [SMProductTool queryData:nil];
}

- (void)setupNav{
    
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftIconBtn = leftItemBtn;
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
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick) forControlEvents:UIControlEventTouchUpInside];

    
    //分享
    UIImage *shareImage = [[UIImage imageNamed:@"nav_share"] scaleToSize:ScaleToSize];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[shareImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnDidClick)];
    UIImage *searchImage = [UIImage imageNamed:@"nav_search"];
    //搜索
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnDidClick)];
    self.navigationItem.rightBarButtonItems = @[shareButton,searchButton];
    
}

#pragma mark -- 导航栏按钮点击
- (void)shareBtnDidClick{
    SMLog(@"点击了 分享微商城");
    [self addShareMemu];
    
}

- (void)searchBtnDidClick{
    SMLog(@"点击了 搜索按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)addShareMemu{
    if (self.cheatView2) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
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
- (void)cancelBtnDidClick{
    [self removeCheatView2];
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
    
    __block SMShoppingController *blockSelf = self;
    
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
        //    NSDate *localeDate = [NSDate date];
        //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        //    SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        //    NSData* iconData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        //    UIImage* icon = [UIImage imageWithData:iconData];
        //    UIImage *iconScaled = [self scaleToSize:icon size:CGSizeMake(100, 100)];
        
        NSString *comName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserEngCompanyName];
        NSString *comID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        NSString *endUrl = [self.baseUrl stringByAppendingString:[NSString stringWithFormat:@"?companyId=%@&saleId=%@",comID,userID]];
        
        //    if (type == 22) { //分享到微信
        //        endUrl = [endUrl stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        //        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        //        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        //        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        //        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        //        SMLog(@"urlStr   %@",endUrl);
        //        endUrl = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:endUrl andMoreinfo:NO];
        //    }
        
        //原图
        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:endUrl] withSize:KScreenWidth];
        
//        //缩略图
//        NSData *imgData = UIImageJPEGRepresentation(qrcode, 1.0);
//        // 原始图片
//        UIImage *result = [UIImage imageWithData:imgData];
//        
//        while (imgData.length > 32 *1000) {
//            imgData = UIImageJPEGRepresentation(result, 0.5);
//            result = [UIImage imageWithData:imgData];
//        }
        
//        SMLog(@"imgData.length   %zd",imgData.length / 1000);
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:@[qrcode]
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
    }else if (type2 == 1){  //分享链接
        //    NSDate *localeDate = [NSDate date];
        //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        //    SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        //    NSData* iconData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        //    UIImage* icon = [UIImage imageWithData:iconData];
        //    UIImage *iconScaled = [self scaleToSize:icon size:CGSizeMake(100, 100)];
        
        NSString *comName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserEngCompanyName];
        NSString *comID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        NSString *endUrl = [self.baseUrl stringByAppendingString:[NSString stringWithFormat:@"?companyId=%@&saleId=%@",comID,userID]];
        NSString *comFullName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
        
        NSString* logoPath = [[NSUserDefaults standardUserDefaults] objectForKey:KUSerComPanyLogoPath];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoPath]]];
        
        /*
        if (type1 == 22) { //分享到微信
            endUrl = [endUrl stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
            endUrl = [endUrl stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
            endUrl = [endUrl stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
            endUrl = [endUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            endUrl = [endUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            SMLog(@"urlStr   %@",endUrl);
            endUrl = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:endUrl andMoreinfo:NO];
        }
         */
        
        //原图
//        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:endUrl] withSize:180];
        //    qrcode = [self scaleToSize:qrcode size:CGSizeMake(150, 150)];
        
        //缩略图
        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
        // 原始图片
        UIImage *result = [UIImage imageWithData:imgData];
        
        while (imgData.length > 32 *1000) {
            imgData = UIImageJPEGRepresentation(result, 0.5);
            result = [UIImage imageWithData:imgData];
        }
        
        SMLog(@"imgData.length   %zd",imgData.length / 1000);
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:comFullName
                                         images:image
                                            url:[NSURL URLWithString:endUrl]
                                          title:comName
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupWeChatParamsByText:comFullName title:comName url:[NSURL URLWithString:endUrl] thumbImage:result image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        
        
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

- (void)leftItemDidClick{
    //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    SMNewPersonInfoController *vc= [[SMNewPersonInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *collectionViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getProductWith:self.sequenceType];
        [self getHotProducts];
    }];
    self.collectionView.mj_header = collectionViewheader;
    
    MJRefreshBackNormalFooter *collectionViewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getProductWith:self.sequenceType];
        
    }];
    self.collectionView.mj_footer = collectionViewfooter;
}

//默认排序 销量优先
- (void)getProductWith:(PRODUCT_SORT_TYPE)type{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:type andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        SMLog(@"self.page  %zd",self.page);
        if (!error) { //请求成功
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
            if (self.page == 1) {
                self.arrProducts = [NSMutableArray arrayWithArray:array];
            }else{
                for (Product *p in array) {
                    [self.arrProducts addObject:p];
                }
            }
            
            [self.collectionView reloadData];
            
            //存本地
            for (Product *p in self.arrProducts) {
                [SMProductTool insertModal:p];
                SMLog(@"存入对象 p %@",p);
            }
            
        }else{ //请求失败
            SMLog(@"error  getHotProducts %@",error);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络异常，请检查网络!"];
        }
    }];
}

- (void)getHotProducts{
    
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Commission_News andClassId:@"" andIsRecommend:(NSInteger)1  block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            if (array.count) {
                [self.arrHotProducts removeAllObjects];
                [LocalHotProductTool deleteData:nil];
                for (Product *p in array) {
                    SMLog(@"p.adImage getHotProducts  %@",p.adImage);
                    self.arrScrollProducts = array;
                    //NSArray *arr = [NSString mj_objectArrayWithKeyValuesArray:p.imagePath];
                    //[self.arrHotProducts addObject:arr.firstObject];
                    if (p.adImage) {
                        [self.arrHotProducts addObject:p.adImage];
                        [LocalHotProductTool insertModal:p];
                    }
                }
                [self.collectionView reloadData];
            }
            
        }else{
            SMLog(@"error  getHotProducts %@",error);
            
        }
        
    }];
}

#pragma mark --<UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.arrHotProducts.count) {
        return 3;
    }else{
        return 2;
    }
    //return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    if (section == 2) {
//        return self.arrProducts.count;
//    }else{
//        return 1;
//    }
    
    if (self.arrHotProducts.count) {
        if (section == 2) {
            return self.arrProducts.count;
        }else{
            return 1;
        }

    }else{
        if (section == 1) {
            return self.arrProducts.count;
        }else{
            return 1;
        }

    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.arrHotProducts.count) {//有广告轮播
        if (indexPath.section == 0) {//广告轮播
            SMNewShoppingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section0ReuserIdentifier forIndexPath:indexPath];
            cell.arrUrls = self.arrHotProducts;
            cell.scrollView.delegate = self;
            return cell;
        }else if (indexPath.section == 1){//工具条
            
            SMNewShoppingSequenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section1ReuserIdentifier forIndexPath:indexPath];
            self.productNewBtn = cell.productNew;
            self.salesCountBtn = cell.salesCountBtn;
            cell.delegate = self;
            return cell;
        }else if (indexPath.section == 2){//商品
            
            SMProductCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:section2ReuserIdentifier forIndexPath:indexPath];
            //SMLog(@"SMProductCollectionViewCell = %@",cell);
            cell.product = self.arrProducts[indexPath.row];
            return cell;
        }
    }else{//没有广告轮播
        if (indexPath.section == 0){//工具条
            SMNewShoppingSequenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section1ReuserIdentifier forIndexPath:indexPath];
            self.productNewBtn = cell.productNew;
            self.salesCountBtn = cell.salesCountBtn;
            cell.delegate = self;
            return cell;
        }else if (indexPath.section == 1){//商品
            SMProductCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:section2ReuserIdentifier forIndexPath:indexPath];
            cell.product = self.arrProducts[indexPath.row];
            return cell;
        }
    }
    return nil;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.arrHotProducts.count) {//有广告轮播
        if (indexPath.section == 0) {
            return CGSizeMake(KScreenWidth , 150 *SMMatchHeight);
        }else if (indexPath.section == 1){
            return CGSizeMake(KScreenWidth , 35 *KMatch);
        }else if (indexPath.section == 2){
            return CGSizeMake((KScreenWidth - 15) / 2.0, 209 *SMMatchHeight);
        }
    }else{
        if (indexPath.section == 0){
            return CGSizeMake(KScreenWidth , 35 *KMatch);
        }else if (indexPath.section == 1){
            return CGSizeMake((KScreenWidth - 15) / 2.0, 209 *SMMatchHeight);
        }
    }
    return CGSizeMake(KScreenWidth , 150 *SMMatchHeight);
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.arrHotProducts.count) {//有广告轮播
        if (section == 0) {
            return UIEdgeInsetsMake(0 ,0 ,0 ,0);
        }else if (section == 1){
            return UIEdgeInsetsMake(0 ,0 ,0 ,0);
        }else if (section == 2){
            return UIEdgeInsetsMake(5 ,5 ,5 ,5);
        }
    }else{
        if (section == 0){
            return UIEdgeInsetsMake(0 ,0 ,0 ,0);
        }else if (section == 1){
            return UIEdgeInsetsMake(5 ,5 ,5 ,5);
        }
    }
    return UIEdgeInsetsMake(0 ,0 ,0 ,0);
}

//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    SMLog(@"点击了 collectionViewCell %zd组  %zd个",indexPath.section,indexPath.row);
    //原生
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//    vc.product = self.arrProducts[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    SMNewProductDetailController *vc = [[SMNewProductDetailController alloc] init];
    vc.product = self.arrProducts[indexPath.row];
    vc.mode = 1;
    vc.productName = [self.arrProducts[indexPath.row] name];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//
//    cell.alpha = 0;
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.alpha = 1;
//    }];
//}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    SMLog(@"---点击了第%ld张图片", index);
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//    vc.product = self.arrScrollProducts[index];
//    [self.navigationController pushViewController:vc animated:YES];
    
    SMNewProductDetailController *vc = [[SMNewProductDetailController alloc] init];
    vc.product = self.arrScrollProducts[index];
    vc.mode = 1;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 排序数据获取及刷新UI
- (void)getProductSortType_Price_Asc{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Price_Asc andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

- (void)getProductSortType_Commission_Asc{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Commission_Asc andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

- (void)getProductSortType_Price_Desc{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Price_Desc andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

- (void)getProductSortType_Commission_Desc{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Commission_Desc andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

#pragma mark -- 点击事件
- (void)topBtnDidClick:(UIButton *)btn viewTag:(int)tag{
    SMLog(@"点击了 弹出来的选择排序  上面的按钮排序");
    [self sequenceViewClick:btn tag:tag];
    
    self.page = 1;
    if (tag == 1) {  //价格从低到高
        self.sequenceType = SortType_Price_Asc;
    }else{   //佣金从低到高
        self.sequenceType = SortType_Commission_Asc;
    }
    [self getProductWith:self.sequenceType];
}

- (void)bottomBtnDidClick:(UIButton *)btn viewTag:(int)tag{
    SMLog(@"点击了 弹出来的选择排序  下面的按钮排序");
    [self sequenceViewClick:btn tag:tag];
    
    self.page = 1;
    if (tag == 1) {   //价格从高到低
        self.sequenceType = SortType_Price_Desc;
    }else{    //佣金从高到低
        self.sequenceType = SortType_Commission_Desc;
    }
    [self getProductWith:self.sequenceType];
}

- (void)sequenceViewClick:(UIButton *)btn tag:(int)tag{
    if (tag == 1) {  //价格排序那边的
        self.priceBtn.selected = YES;
        self.salesCountBtn.selected = NO;
        self.commisionBtn.selected = NO;
        self.productNewBtn.selected = NO;
        [self.priceBtn setTitle:btn.currentTitle forState:UIControlStateSelected];
        [self.priceBtn setImage:[UIImage imageNamed:@"产品库sahng"] forState:UIControlStateSelected];
        [self cheatViewTap];
    }else{   //佣金排序那边的
        self.priceBtn.selected = NO;
        self.salesCountBtn.selected = NO;
        self.commisionBtn.selected = YES;
        self.productNewBtn.selected = NO;
        [self.commisionBtn setTitle:btn.currentTitle forState:UIControlStateSelected];
        [self.commisionBtn setImage:[UIImage imageNamed:@"产品库sahng"] forState:UIControlStateSelected];
        [self cheatViewTap];
    }
}

- (void)productNewDidClick:(UIButton *)btn{
    SMLog(@"点击了 新品");
    self.productNewBtn = btn;
    self.productNewBtn.selected = YES;
    self.salesCountBtn.selected = NO;
    self.priceBtn.selected = NO;
    self.commisionBtn.selected = NO;
    
    self.page = 1;
    self.sequenceType = SortType_Commission_News;
    [self getProductWith:SortType_Commission_News];
    
}

- (void)priceDidClick:(UIButton *)btn{
    SMLog(@"点击了 价格排序");
    self.priceBtn = btn;
//    UIImage *image = btn.imageView.image;
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewLeft];
}

- (void)commisionDidClick:(UIButton *)btn{
    SMLog(@"点击了 佣金排序");
    self.commisionBtn = btn;
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewRight];
}

- (void)salesCountDidClick:(UIButton *)btn{
    SMLog(@"点击了 销量优先");
    self.salesCountBtn.selected = YES;
    self.priceBtn.selected = NO;
    self.commisionBtn.selected = NO;
    self.productNewBtn.selected = NO;
    
    self.page = 1;
    self.sequenceType = SortType_Default;
    [self getProductWith:SortType_Default];
    
}

- (void)classesDidClick{
    SMLog(@"点击了 分类");
//    SMProductClassesController *vc = [[SMProductClassesController alloc] init];
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    SMClassesController *vc = [SMClassesController new];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -- 懒加载
- (UIView *)cheatView{
    if (_cheatView == nil) {
        _cheatView = [[UIView alloc] init];
        _cheatView.frame = self.window.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
        [_cheatView addGestureRecognizer:tap];
    }
    return _cheatView;
}

- (void)cheatViewTap{
    [self.cheatView removeFromSuperview];
    self.cheatView = nil;
    [self.sequenceViewLeft removeFromSuperview];
    self.sequenceViewLeft = nil;
    [self.sequenceViewRight removeFromSuperview];
    self.sequenceViewRight = nil;
}

- (SMSequenceView *)sequenceViewLeft{
    if (_sequenceViewLeft == nil) {
        _sequenceViewLeft = [SMSequenceView sequenceViewWithTopTitle:@"价格从低到高" bottomTitle:@"价格从高到低"];
        _sequenceViewLeft.delegate = self;
        _sequenceViewLeft.tag = 1;
        CGFloat width = (KScreenWidth - KScreenWidth / 8.0 - 60) / 2.0;
        CGFloat y = CGRectGetMaxY([self.priceBtn.superview convertRect:self.priceBtn.frame toView:self.window]);
        SMLog(@"y  SMSequenceView %f",y);
        _sequenceViewLeft.frame = CGRectMake(0, y , width, 64 *SMMatchHeight);
    }
    return _sequenceViewLeft;
}

- (SMSequenceView *)sequenceViewRight{
    if (_sequenceViewRight == nil) {
        _sequenceViewRight = [SMSequenceView sequenceViewWithTopTitle:@"佣金从低到高" bottomTitle:@"佣金从高到低"];
        _sequenceViewRight.delegate = self;
        _sequenceViewRight.tag = 2;
        CGFloat width = (KScreenWidth - KScreenWidth / 8.0 - 60) / 2.0;
        CGFloat y = CGRectGetMaxY([self.commisionBtn.superview convertRect:self.commisionBtn.frame toView:self.window]);
        SMLog(@"y  SMSequenceView %f",y);
        _sequenceViewRight.frame = CGRectMake(width + 60, y , width, 64 *SMMatchHeight);

    }
    return _sequenceViewRight;
}

- (NSMutableArray *)arrHotProducts{
    if (_arrHotProducts == nil) {
        _arrHotProducts = [NSMutableArray array];
    }
    return _arrHotProducts;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = KControllerBackGroundColor;
        _collectionView. delegate = self;
        _collectionView. dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
}

@end
