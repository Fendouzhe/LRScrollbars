//
//  SMOrderDetailViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailViewController.h"
#import "SMOrderDetailSection0Cell.h"
#import "SMOrderDetailSection1Cell.h"
#import "SMOrderManagerCell.h"
#import "SMOrderDetailFootterView.h"
#import "SMStatusTrackingViewController.h"
#import "SMOrderDetailFooterView0.h"
#import "SMProductDetailController.h"
#import "AppDelegate.h"
#import "SMPayViewController.h"
#import "SMShareMenu.h"
#import "SMStatusTrackingViewController.h"
#import "SMNewProductDetailController.h"
#import "SMActiveQcodeView.h"

@interface SMOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SMShareMenuDelegate,SMActiveQcodeViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIAlertView * alerView;

@property (nonatomic ,strong)UIView *cheatView2;/**< <#注释#> */

@property (nonatomic ,strong)SMShareMenu *menu;/**< <#注释#> */

@property (nonatomic ,assign)BOOL isGettingMinPrice; /**< 正在请求最小值 */

@property (nonatomic ,assign)CGFloat tableViewHeight; /**< <#注释#> */
//二维码View
@property (nonatomic ,strong)SMActiveQcodeView *qcodeView;
//蒙版
@property (nonatomic ,strong)UIView *coverView;
@end

@implementation SMOrderDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    if (!self.pushedByRefund || !self.pushedBuyClosed) {
        self.tableViewHeight = KScreenHeight - 64 - 49;
    }else{
        self.tableViewHeight = KScreenHeight-64;
    }
    [self setupTableView];
    [self requestNewData];
    
    [self setupQcode];
    
}
//设置二维码图片
- (void)setupQcode{
    NSLog(@"self.salesOrder.type = %lu self.salesOrder.sn = %@ self.orderProduct.productName = %@ ",self.salesOrder.type,self.salesOrder.sn,self.orderProduct.productName);
    //活动邀请
    if (self.salesOrder.type == 2) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //蒙版
        UIView *coverView = [[UIView alloc] initWithFrame:window.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [window addSubview:coverView];
        self.coverView = coverView;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)];
//        [coverView addGestureRecognizer:tap];
        
        //创建二维码
        SMActiveQcodeView *qcodeView = [SMActiveQcodeView activeQcodeView];
        qcodeView.bounds = CGRectMake(0, 0, 260*KMatch, 488*KMatch);
        qcodeView.center = window.center;
        qcodeView.delegate = self;
        [window addSubview:qcodeView];
        //原图
        UIImage *qrcodeImage = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:[NSString stringWithFormat:@"SK-REGISTRATION_EVENT:%@",self.salesOrder.sn]] withSize:qcodeView.qcodeImageView.width];
//        //缩略图
//        NSData *imgData = UIImageJPEGRepresentation(qrcodeImage, 1.0);
//        // 原始图片
//        UIImage *result = [UIImage imageWithData:imgData];
        qcodeView.qcodeImageView.image = qrcodeImage;
        //SMLog(@"self.products = %@",self.products);
        OrderProduct *product = [self.products firstObject];
        qcodeView.productName.text = product.productName;
        self.qcodeView = qcodeView;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            coverView.alpha = 0.7;
        }];
        
    }
}
//蒙版点击
- (void)coverViewTap:(UITapGestureRecognizer *)tap{
    [tap.view removeFromSuperview];
    [self.qcodeView removeFromSuperview];
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

#pragma mark - SMActiveQcodeViewDelegate
///保存到相册
- (void)saveToPhotoWithSMActiveQcodeView:(SMActiveQcodeView *)QcodeView{
    UIImage *newImage = [self getImage];//[[self getImage] scaleToSize:self.view.bounds.size];
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

///隐藏
- (void)hiddenWithSMActiveQcodeView:(SMActiveQcodeView *)QcodeView{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0.0;
        self.qcodeView.transform = CGAffineTransformScale(self.qcodeView.transform, 0.0, 0.0);
    } completion:^(BOOL finished) {
        [self.qcodeView removeFromSuperview];
        [self.coverView removeFromSuperview];
        self.qcodeView = nil;
        self.coverView = nil;
    }];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){
        
        [MBProgressHUD showError:@"保存失败!"];
    }else{
        
        [MBProgressHUD showSuccess:@"保存成功!"];
    }
}

- (UIImage *)getImage{
    //开启图形上下文
    
//    if([[UIScreen mainScreen] scale] == 2.0){
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 2.0);
//    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 3.0);
//    }else {
//        UIGraphicsBeginImageContext(self.qcodeView.qcodeView.size);
//    }
    
    UIGraphicsBeginImageContext(self.qcodeView.qcodeView.size);
    //获取图形上下文
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    //作用：就是把View内部图层上的内容 绘制到 上下文当中
    //截取哪块取决于这个View
    [self.qcodeView.qcodeView.layer renderInContext:ctx];
    //回去绘制号的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    if (!self.pushedByRefund) {  //从退款售后商品push、进来时不显示 bottomview
        [self setupFooterView];
    }
}



-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (void)setupNav{
    self.title = @"订单详情";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    
//    if (!self.pushedByWaitForPay) { //如果是从未付款界面 push 过来的，就隐藏“物流状态”
//        UIButton *rightBtn = [[UIButton alloc] init];
//        rightBtn.width = 70;
//        rightBtn.height = 25;
//        //    rightBtn.backgroundColor = [UIColor greenColor];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = KDefaultFontBig;
//        dict[NSForegroundColorAttributeName] = KRedColorLight;
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"物流状态" attributes:dict];
//        [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        self.navigationItem.rightBarButtonItem = rightItem;
//    }

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
 
}

- (void)rightItemClick{
    SMLog(@"点击了 右上角的分享");
    
    [self addShareMemu];
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
    
    NSDate *localeDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SMLog(@"timeSp :%@",timeSp); //时间戳的值
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    //不能大于32K  6plus 58*3 * 58*3
    UIImage* originImage = [[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(58, 58)];

    //SMLog(@"imgData.length   %zd",imageData.length / 1000);
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//    NSString *eid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    
//    NSString *para = [NSString stringWithFormat:@"?uid=%@&eid=%@&t=%@",uid,eid,timeSp];
//    NSString *path = KInvitePartner;
//    NSURL *url = [NSURL URLWithString:[path stringByAppendingString:para]];
    
    NSString *paraStr = [NSString stringWithFormat:@"?sharey=on&oid=%@&uid=%@",self.salesOrder.id,uid];
    NSString *endUrl = [KOrderDetailShare stringByAppendingString:paraStr];
    
    /*
    if (type == 22) { //分享到微信
        endUrl = [endUrl stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        endUrl = [endUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        SMLog(@"urlStr   %@",endUrl);
        endUrl = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:endUrl andMoreinfo:NO];
    }
     */
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"爽快订单:%@",self.salesOrder.sn]
                                     images:originImage
                                        url:[NSURL URLWithString:endUrl]
                                      title:[NSString stringWithFormat:@"掌柜:%@",name]
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

- (void)cancelBtnDidClick{
    [self removeCheatView2];
}

-(void)setupFooterView{
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.with.offset(49);
    }];

    CGFloat margin = 8;
    CGFloat w = (KScreenWidth - margin *5) / 4.0;
    NSNumber *width = [NSNumber numberWithFloat:w];
    NSNumber *height = [NSNumber numberWithFloat:32];
    
    UIButton * btn0 = [[UIButton alloc]init];
    btn0.backgroundColor = KRedColorLight;
    btn0.layer.cornerRadius = 4;
    btn0.layer.masksToBounds = YES;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = KDefaultFont;
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [btn0 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"完成订单" attributes:dic] forState:UIControlStateNormal];
//    [btn0 addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:btn0];
    [footerView addSubview:btn0];
    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView.mas_right).with.offset(-margin);
        make.centerY.equalTo(footerView.mas_centerY);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    
    
    UIButton * btn1 = [[UIButton alloc]init];
    btn1.layer.borderColor = KRedColorLight.CGColor;
    btn1.layer.borderWidth = 0.5;
    btn1.layer.cornerRadius = 4;
    btn1.layer.masksToBounds = YES;
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
    dic1[NSFontAttributeName] = KDefaultFont;
    dic1[NSForegroundColorAttributeName] = KRedColorLight;
    [footerView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(footerView.mas_centerY);
        make.right.equalTo(btn0.mas_left).with.offset(-margin);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    
    
    UIButton * btn2 = [[UIButton alloc]init];
    btn2.layer.borderColor = KRedColorLight.CGColor;
    btn2.layer.borderWidth = 0.5;
    btn2.layer.cornerRadius = 4;
    btn2.layer.masksToBounds = YES;
    NSMutableDictionary * dic2 = [NSMutableDictionary dictionary];
    dic2[NSFontAttributeName] = KDefaultFont;
    dic2[NSForegroundColorAttributeName] = KRedColorLight;
    [footerView addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(footerView.mas_centerY);
        make.right.equalTo(btn1.mas_left).with.offset(-margin);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    
    
    UIButton * btn3 = [[UIButton alloc]init];
    btn3.layer.borderColor = KRedColorLight.CGColor;
    btn3.layer.borderWidth = 0.5;
    btn3.layer.cornerRadius = 4;
    btn3.layer.masksToBounds = YES;
    NSMutableDictionary * dic3 = [NSMutableDictionary dictionary];
    dic3[NSFontAttributeName] = KDefaultFont;
    dic3[NSForegroundColorAttributeName] = KRedColorLight;
    [footerView addSubview:btn3];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(footerView.mas_centerY);
        make.right.equalTo(btn2.mas_left).with.offset(-margin);
        make.width.equalTo(width);
        make.height.equalTo(height);
    }];
    
    
    
    if (self.salesOrder.status == 0) { //待付款
        btn0.hidden = NO;
        btn1.hidden = NO;
        btn2.hidden = NO;
        btn3.hidden = YES;
        [btn0 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"重新支付" attributes:dic] forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(rePayClick) forControlEvents:UIControlEventTouchUpInside];
        
        [btn1 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"修改价格" attributes:dic1] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(changePriceClick) forControlEvents:UIControlEventTouchUpInside];
        
//        [btn2 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"修改运费" attributes:dic2] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(changeFreightClick) forControlEvents:UIControlEventTouchUpInside];
        
        [btn2 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"关闭订单" attributes:dic2] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(closeOrderClick) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.salesOrder.status == 1){//待发货
        btn0.hidden = NO;
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
        [btn0 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"提醒发货" attributes:dic] forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(remindDispatchGoodsClick) forControlEvents:UIControlEventTouchUpInside];

    }else if (self.salesOrder.status == 2){//已发货
        btn0.hidden = NO;
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
        [btn0 setAttributedTitle:[[NSAttributedString alloc]initWithString:@"查看物流" attributes:dic] forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(chechLogisticsClick) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.salesOrder.status == 3){//已完成
        btn0.hidden = YES;
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
    }else if (self.salesOrder.status == 4){//已关闭
        btn0.hidden = YES;
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
    }
    
}

#pragma mark -- 点击事件
-(void)chechLogisticsClick{
    SMLog(@"点击了 查看物流");
    SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
    trackingVc.orderString = self.salesOrder.sn;
    trackingVc.saleOrder = self.salesOrder;
    [self.navigationController pushViewController:trackingVc animated:YES];
}
- (void)remindDispatchGoodsClick{
    SMLog(@"点击了 提醒发货");
    [[SKAPI shared] remindOrder:self.salesOrder.id block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            [MBProgressHUD showSuccess:@"提醒成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)closeOrderClick{
    SMLog(@"点击了 关闭订单");
    [[SKAPI shared] closeOrder:self.salesOrder.id block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
    
}

- (void)changeFreightClick{
    SMLog(@"点击了 修改运费"); //现在没有修改运费
}

- (void)changePriceClick{
    SMLog(@"点击了 修改价格");
    if (self.isGettingMinPrice) {  //防止同时弹出多个修改价格的提示框
        return;
    }
    
    self.isGettingMinPrice = YES;
    //查看最低价格限制
    [[SKAPI shared] queryMinOrderPayMoney:self.salesOrder.id block:^(id result, NSError *error) {
        if (!error) {
            self.isGettingMinPrice = NO;
            SMLog(@"result   queryMinOrderPayMoney  %@",result);
            NSDictionary *dict = [result objectForKey:@"result"];
            NSNumber *minPrice = dict[@"min_paymoney"];
            [self showAlertEdit:minPrice];
        }else{
            SMLog(@"error   %@",error);
            self.isGettingMinPrice = NO;
        }
    }];
 
}

- (void)showAlertEdit:(NSNumber *)minPrice{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    SCLTextView *textField = [alert addTextField:@"请输最终总价(单位：元)"];
    alert.showAnimationType = SlideInToCenter;
    alert.hideAnimationType = SlideOutFromCenter;
    [alert addButton:@"确定" actionBlock:^(void) {
        
        SMLog(@"Text value: %@", textField.text);
        if (textField.text.floatValue < minPrice.floatValue) {
            [self showError];
            return;
        }
        [[SKAPI shared] adjustOrderPayMoney:self.salesOrder.id andMoney:[NSNumber numberWithFloat:textField.text.floatValue] block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  adjustOrderPayMoney   %@",result);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"改价成功！"];
                });
                
                [self requestNewData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            }else{
                SMLog(@"error   %@",error);
            }
        }];
    }];
    
    SCLButton *cancelBtn = [alert addButton:@"取消" actionBlock:^{
        
    }];
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
    
    [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:KRedColorAlert title:@"修改总价" subTitle:[NSString stringWithFormat:@"温馨提示：修改总价后，您的佣金也会自动作出相应的调整.(由于商家成本因素，此订单最低调价为%@元)",minPrice] closeButtonTitle:nil duration:0];
}

- (void)showError{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SlideInFromCenter;
    alert.hideAnimationType = SlideOutToCenter;
    [alert showError:self title:@"提示" subTitle:@"您输入的总价低于最低限定价格，请重新输入" closeButtonTitle:@"确定" duration:0];
}

- (void)rePayClick{
    SMLog(@"点击了 重新支付");
    SMPayViewController * payViewC = [SMPayViewController new];
    payViewC.orderStr = self.salesOrder.sn;
    [self.navigationController pushViewController:payViewC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }else if (section == 1){//收获信息
        return 1;
    }else{//订单商品
        return self.products.count+2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMOrderDetailSection0Cell *cell = [SMOrderDetailSection0Cell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"订单编号";
            cell.rightLabel.text = @"888201512251140666";
            
            cell.rightLabel.text = self.salesOrder.sn;
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"成交时间";
            cell.rightLabel.text = @"2015-12-25 11:40:10";
            if (self.salesOrder.createAt == 0) {
                cell.rightLabel.text = [NSString stringWithFormat:@"%@",@"尚未成交"];
            }else{
                cell.rightLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",self.salesOrder.createAt]];
            }
        }else if (indexPath.row == 2){
            cell.leftLabel.text = @"付款时间";
            cell.rightLabel.text = @"2015-12-25 11:40:10";
            if (self.salesOrder.payTime == 0) {

                cell.rightLabel.text = [NSString stringWithFormat:@"%@",@"尚未付款"];
            }else{
                cell.rightLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",self.salesOrder.payTime]];
            }
            
        }else if (indexPath.row == 3){
            cell.leftLabel.text = @"发货时间";
            cell.rightLabel.text = @"2015-12-25 11:40:10";
            
            if (self.salesOrder.sendTime == 0) {
                
                cell.rightLabel.text = [NSString stringWithFormat:@"%@",@"尚未发货"];
            }else{
                cell.rightLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",self.salesOrder.sendTime]];
            }
        }else if (indexPath.row == 4){
            
            cell.leftLabel.text = @"应付金额";
//            cell.rightLabel.text = @"￥400.00（包运费10.00）";
            
            cell.rightLabel.text = [NSString stringWithFormat:@"￥%.2lf",self.salesOrder.payMoney];
            SMLog(@"self.salesOrder.sumPrice   %.2f",self.salesOrder.sumPrice);
        }else if (indexPath.row == 5){
            
            cell.leftLabel.text = @"实付金额";
//            cell.rightLabel.text = @"￥00.00";
            
            cell.rightLabel.text = [NSString stringWithFormat:@"￥%.2lf (包运费￥%.2lf)",self.salesOrder.realPayMoney,self.salesOrder.shippingFee];
            SMLog(@"self.salesOrder.realPayMoney    %.2f ",self.salesOrder.realPayMoney);
            
        }else if (indexPath.row == 6){
            cell.leftLabel.text = @"佣金总额";
            cell.rightLabel.text = @"￥100";
            
            cell.rightLabel.text =  [NSString stringWithFormat:@"￥%.2lf",self.salesOrder.sumCommission];
        }else if (indexPath.row == 7){
            cell.leftLabel.text = @"订单状态";
            cell.rightLabel.text = @"已发货";
            
            if (self.salesOrder.status == 0) {
                cell.rightLabel.text = @"待付款";
            }else if(self.salesOrder.status == 1){
                cell.rightLabel.text = @"已付款";
            }else if(self.salesOrder.status == 2){
                cell.rightLabel.text = @"已发货";
            }else if (self.salesOrder.status == 3){
                cell.rightLabel.text = @"已完成";
            }else if (self.salesOrder.status == 4){
                cell.rightLabel.text = @"已关闭";
            }else if (self.salesOrder.status == 5){
                cell.rightLabel.text = @"退款中";
            }else if (self.salesOrder.status == 6){
                cell.rightLabel.text = @"已退款";
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        SMOrderDetailSection1Cell *cell = [SMOrderDetailSection1Cell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.receiverNameLabel.text = [NSString stringWithFormat:@"收货人:%@ %@",self.salesOrder.buyerName,self.salesOrder.buyerPhone];
        cell.addressLabel.text = [NSString stringWithFormat:@"收货人地址:%@",self.salesOrder.buyerAddress];
        
        return cell;
    }
    else{//最后一组
        if (indexPath.row < self.products.count) {
            SMOrderManagerCell *cell = [SMOrderManagerCell cellWithTableView:tableView];
            [cell refrshUI:self.products[indexPath.row]];
            return cell;
        }else{
            SMOrderDetailSection0Cell *cell = [SMOrderDetailSection0Cell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == self.products.count) {
                cell.leftLabel.text = @"购买数量";
                cell.rightLabel.text = @"2";
                cell.rightLabel.textColor = KRedColor;
                
                cell.rightLabel.text = [NSString stringWithFormat:@"%ld",self.salesOrder.sumAmount];
            }else{
                cell.leftLabel.text = @"运费";
                cell.rightLabel.text = @"￥10.00";
                
                cell.rightLabel.text = [NSString stringWithFormat:@"￥%.2lf",self.salesOrder.shippingFee];
            }
            return cell;  
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 38;
    }else if (indexPath.section == 1){
        return 62;
    }else{
        if (indexPath.row < self.products.count) {
            return 84;
        }else{
            return 41;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else{
        SMOrderDetailFootterView *header = [SMOrderDetailFootterView orderDetailFootterView];
        if (section == 1) {
            header.titleLabel.text = @"收货信息";
        }else{
            header.titleLabel.text = @"订单商品";
        }
        return header;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section==2) {
//        SMOrderDetailFooterView0 * footer = [[[NSBundle mainBundle] loadNibNamed:@"SMOrderDetailFooterView0" owner:nil options:nil] lastObject];
//        footer.pushBlock = ^(UIViewController * Vc){
//            [self.navigationController pushViewController:Vc animated:YES];
//        };
//        footer.popBlock = ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        };
//        footer.ID = self.salesOrder.sn;
//        footer.state = self.salesOrder.status;
//        return footer;
//    }
//    return nil;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section==2) {
//        return 60;
//    }
//    return 1;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return nil;
//    }else if (section == 1){
//        return @"收货信息";
//    }else{
//        return @"订单商品";
//    }
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 33;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击 切换到产品详情....
    if (indexPath.section==2) {
        //第二段
        //对应ID   
        if (indexPath.row<self.products.count) {
//            SMProductDetailController * detail = [SMProductDetailController new];
//            Product * product = [Product new];
//            OrderProduct * order = self.products[indexPath.row];
//            product.id = order.productId;
//            detail.product = product;
//            [self.navigationController pushViewController:detail animated:YES];
            
            SMNewProductDetailController *vc = [SMNewProductDetailController new];
            OrderProduct * order = self.products[indexPath.row];
            vc.productId = order.productId;
            vc.mode = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 状态跟踪 按钮");
    
    SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
    trackingVc.orderString = self.salesOrder.sn;
    trackingVc.saleOrder = self.salesOrder;
    SMLog(@"%@",trackingVc.saleOrder.comCode);
    [self.navigationController pushViewController:trackingVc animated:YES];
}

-(void)setSalesOrder:(SalesOrder *)salesOrder
{
    _salesOrder = salesOrder;
}

-(void)requestNewData{
    
    [[SKAPI shared] queryOrder:self.salesOrder.sn block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"%@",result);
            
            SalesOrder * order = (SalesOrder *)result;
            
            self.salesOrder = order;
            
            self.products = order.products;
            
            [self.tableView reloadData];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
//    self.products = self.salesOrder.products;
}

-(void)finishBtnClick:(UIButton *)btn{
    //完成订单 or  关闭订单
    if (self.salesOrder.status == 0) {
        //关闭订单
        [self closeOrder];
    }else{
        //完成订单
        [self finishOrder];
    }
}

-(void)logisticsBtnClick:(UIButton *)btn{
    //物流状态  or 重新支付
    if (self.salesOrder.status == 0) {
        //重新支付
        SMPayViewController * payViewC = [SMPayViewController new];
        payViewC.orderStr = self.salesOrder.sn;
        [self.navigationController pushViewController:payViewC animated:YES];
    }else{
        //物流状态
        SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
        trackingVc.orderString = self.salesOrder.sn;
        [self.navigationController pushViewController:trackingVc animated:YES];
    }
}

-(void)closeOrder
{
    [[SKAPI shared] closeOrder:self.salesOrder.sn block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@     self.salesOrder.sn   %@",result,self.salesOrder.sn);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            [self showAlertViewMessage:@"已关闭订单"];
        }else
        {
            SMLog(@"%@    self.salesOrder.sn   %@",error,self.salesOrder.sn);
        }
    }];
}

-(void)finishOrder
{
    [[SKAPI shared] finishOrder:self.salesOrder.sn block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            [self showAlertViewMessage:@"已完成订单"];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)showAlertViewMessage:(NSString *)message
{
    if (!_alerView) {
        self.alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.alerView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        alertView = nil;
    }
}
@end
