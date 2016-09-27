//
//  SMPosterDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPosterDetailController.h"
#import <UIImageView+WebCache.h>
#import "SMShareMenu.h"

@interface SMPosterDetailController () <SMShareMenuDelegate>

@property (nonatomic ,strong) UIScrollView *scrollVc; /** 滚动的View */

@property (nonatomic ,strong) UIImageView *imageVc; /** 海报图片 */

@property (nonatomic ,strong) UIView *buttomView; /** 底部的View */

@property (nonatomic ,strong) UIImageView *iconView; /** 图片的View */

@property (nonatomic ,strong) UIImageView *erWeiMaView; /** 二维码View */

@property (nonatomic, strong) UILabel *titleLabel; /** 尊称Label */

@property (nonatomic ,strong) UILabel *contentLabel; /** 内容Label */

@property (nonatomic ,strong) UILabel *promptLabel; /** 二维码提示Label */

@property (nonatomic ,copy) NSString *ticket;/**< <#注释#> */

@property (nonatomic ,strong) UIImage *shareImage;/**< <#注释#> */

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;

@end

@implementation SMPosterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = _listModle.adName;
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self setupScrillView];
    
    [self addChildView];
    
    [self setupNav];
    
    [self setupData];
}


- (void)setupScrillView
{
    UIScrollView *scrollVc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    
//    scrollVc.backgroundColor = [UIColor yellowColor];
//    scrollVc.showsVerticalScrollIndicator = NO;
    
    scrollVc.contentSize = CGSizeMake(KScreenWidth, 855*SMMatchWidth);

    
    self.scrollVc = scrollVc;
    
    [self.view addSubview:scrollVc];
}



- (void)addChildView
{
    // 海报大图
    UIImageView *imageVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 650*SMMatchWidth)];
    
//    imageVc.backgroundColor = [UIColor blueColor];
    
    self.imageVc = imageVc;
    
    [self.scrollVc addSubview:imageVc];
    
    
    // 底部的View
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, 650*SMMatchWidth, KScreenWidth, 120*SMMatchWidth)];
    
    buttomView.backgroundColor = [UIColor whiteColor];
    
    self.buttomView = buttomView;
    
    [self.scrollVc addSubview:buttomView];
    
    
    // 头像的View
    UIImageView *iconView = [[UIImageView alloc]init];
    
//    iconView.backgroundColor = [UIColor purpleColor];
    
    self.iconView = iconView;
    
    self.iconView.layer.cornerRadius = 74 *SMMatchWidth * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    [self.buttomView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.buttomView.mas_left).offset(5*SMMatchWidth);
        make.centerY.equalTo(self.buttomView);
        make.width.equalTo(@(74*SMMatchWidth));
        make.height.equalTo(@(74*SMMatchWidth));
    }];
    

    // 尊称文字
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.text = @"尊敬的客户:";
    
    titleLabel.font = KDefaultFontSmall;
    
    self.titleLabel = titleLabel;
    
    [self.buttomView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconView.mas_right).offset(10*SMMatchWidth);
        make.top.equalTo(self.iconView.mas_top).offset(5*SMMatchWidth);
    }];
    
    
    // 内容文字
    UILabel *contentLabel = [[UILabel alloc]init];
    
    contentLabel.font = KDefaultFontSmall;
    
    contentLabel.numberOfLines = 0;
    
    self.contentLabel = contentLabel;
    
    [self.buttomView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_left);
        make.width.equalTo(@(KScreenWidth - 74*SMMatchWidth - 90*SMMatchWidth - 25*SMMatchWidth));
        make.centerY.equalTo(self.iconView.mas_centerY).offset(-7*SMMatchWidth);
    }];
    
    
    // 二维码提示文字
    UILabel *promptLabel = [[UILabel alloc]init];
    
    promptLabel.text = @"长按识别右边的二维码,会有更多惊喜哦!";
    
    promptLabel.font = KDefaultFontSmall;
    
    promptLabel.numberOfLines = 0;
    
    self.promptLabel = promptLabel;
    
    [self.buttomView addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         
        make.left.equalTo(self.titleLabel.mas_left);
        make.width.equalTo(@(KScreenWidth - 74*SMMatchWidth - 90*SMMatchWidth - 25*SMMatchWidth));
        make.bottom.equalTo(self.iconView.mas_bottom).offset(-5*SMMatchWidth);
    }];
    
    // 二维码的View
    UIImageView *erWeiMaView = [[UIImageView alloc]init];
    
//    erWeiMaView.backgroundColor = [UIColor cyanColor];
    
    self.erWeiMaView = erWeiMaView;
    erWeiMaView.image = [UIImage imageNamed:@"220"];
    [self.buttomView addSubview:erWeiMaView];
    
    [erWeiMaView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.buttomView.mas_right).offset(-5*SMMatchWidth);
        make.centerY.equalTo(self.buttomView);
        make.width.equalTo(@(90*SMMatchWidth));
        make.height.equalTo(@(90*SMMatchWidth));
    }];
    
}


- (void)setupData{
    
    NSString *imagePath = [self.listModle.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",300 * 2 * SMMatchWidth,368 * 2 * SMMatchHeight]];
    //加载器
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = self.imageVc.bounds;
    [self.imageVc addSubview:indicatorView];
    [indicatorView startAnimating];
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"] options:SDWebImageRetryFailed];
    [self.imageVc setShowActivityIndicatorView:YES];
    [self.imageVc setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imageVc sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [indicatorView stopAnimating];
        
        SMLog(@"%f", image.size.height);
        
        SMLog(@"%f", image.size.width);
        
        CGFloat scrollVcH = image.size.height / image.size.width * KScreenWidth;
        
        SMLog(@"%f", scrollVcH);
        
        self.scrollVc.contentSize = CGSizeMake(KScreenWidth, (scrollVcH + 120)*SMMatchWidth);
        
        if (scrollVcH < 120) {
            self.imageVc.height = 150 * SMMatchWidth;
            self.buttomView.y =  self.imageVc.height;
        }else
        {
            self.imageVc.height = scrollVcH*SMMatchWidth;
            self.buttomView.y = self.imageVc.height;
        }
        
    }];
    self.contentLabel.text = [NSString stringWithFormat:@"您好!我是您可信赖的朋友—%@;",[[NSUserDefaults standardUserDefaults] objectForKey:KUserName]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    self.iconView.image = image;
    
    [self setUpErWeiMa];
    
}

- (void)setUpErWeiMa{
    
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *userIdStr = [NSString stringWithFormat:@"scene_str%@",userId];
    //加载器

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.erWeiMaView addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.erWeiMaView);
    }];
    [indicatorView startAnimating];
    
    [[SKAPI shared] getWeiXinQrcodeWithCompanyId:companyId userIdStr:userIdStr block:^(id result, NSError *error) {
        if (!error) {
            self.ticket = result;
            //NSString *qrcodeStr = [SKAPI_PREFIX_SHARE stringByAppendingString:[NSString stringWithFormat:@"/weixin/qrcode?ticket=%@",self.ticket]];
            NSString *qrcodeStr = [SKAPI_PREFIX_SHARE stringByAppendingString:[NSString stringWithFormat:@"mall.html?companyId=%@&saleId=%@",companyId,userId]];
            UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrcodeStr] withSize:150];
            
            self.erWeiMaView.image = qrcode;
            SMLog(@"qrcodeStr  setUpErWeiMa  %@",qrcodeStr);
        }else{
            SMLog(@"error  %@",error);
            [MBProgressHUD showError:@"获取二维码失败!"];
        }
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
    }];
    
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

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

- (void)setupNav{
    UIButton *buttpon = [[UIButton alloc] init];
    [buttpon setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [buttpon addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    buttpon.size = ScaleToSize;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttpon];
}

- (void)share{
    
    SMLog(@"share");
    self.shareImage = [self captureScrollView];
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

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    [shareParams SSDKSetupShareParamsByText:self.title
    //                                     images:imageArray
    //                                        url:[NSURL URLWithString:urlChang5]
    //                                      title:[NSString stringWithFormat:@"%@",self.title]
    //                                       type:SSDKContentTypeAuto];
    
    //    long length = UIImageJPEGRepresentation(self.shareImage, 0.1).length / 1000;
    SMLog(@"length  %@",_shareImage);
    //    UIImage * image = [UIImage imageWithData:UIImageJPEGRepresentation(self.shareImage, 0.1)];
    
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:@[_shareImage]
                                        url:nil
                                      title:nil
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
    
    [self removeCheatView3];
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

///截图方法
//- (UIImage *)getImage{
//    //开启图形上下文
//    if([[UIScreen mainScreen] scale] == 2.0){
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 2.0);
//    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 3.0);
//    }else {
//        UIGraphicsBeginImageContext(self.view.frame.size);
//    }
//    //获取图形上下文
//    CGContextRef ctx =  UIGraphicsGetCurrentContext();
//    //作用：就是把View内部图层上的内容 绘制到 上下文当中
//    //截取哪块取决于这个View
//    [self.view.layer renderInContext:ctx];
//    //回去绘制号的图片
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭图形上下文
//    UIGraphicsEndImageContext();
//    return newImage;
//    
//}

- (UIImage *)captureScrollView{
    UIImage* image = nil;
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(_scrollVc.contentSize, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
        UIGraphicsBeginImageContextWithOptions(_scrollVc.contentSize, NO, 3.0);
    }else {
//        UIGraphicsBeginImageContext(self.view.frame.size);
    UIGraphicsBeginImageContext(_scrollVc.contentSize);
    }
    {
        CGPoint savedContentOffset = _scrollVc.contentOffset;
        CGRect savedFrame = _scrollVc.frame;
        _scrollVc.contentOffset = CGPointZero;
        _scrollVc.frame = CGRectMake(0, 0, _scrollVc.contentSize.width*SMMatchWidth, _scrollVc.contentSize.height*SMMatchWidth);
        
        [_scrollVc.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollVc.contentOffset = savedContentOffset;
        _scrollVc.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}


@end
