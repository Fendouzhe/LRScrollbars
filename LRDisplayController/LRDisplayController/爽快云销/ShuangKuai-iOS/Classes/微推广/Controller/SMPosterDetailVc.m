//
//  SMPosterDetailVc.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPosterDetailVc.h"
#import <UIImageView+WebCache.h>
#import "SMShareMenu.h"

@interface SMPosterDetailVc ()<SMShareMenuDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIImageView *erWeiMa;

@property (weak, nonatomic) IBOutlet UIButton *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (nonatomic ,copy)NSString *ticket;/**< <#注释#> */

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *erWeiMaHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *erWeiMaWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIconWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIconHeight;


@property (nonatomic ,strong)UIImage *shareImage;/**< <#注释#> */

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;


@end

@implementation SMPosterDetailVc


- (void)setup{
    
    self.erWeiMaHeight.constant = 80 *SMMatchWidth;
    self.erWeiMaWidth.constant = 80 *SMMatchWidth;
    self.userIconWidth.constant = 50 *SMMatchWidth;
    self.userIconHeight.constant = 50 *SMMatchWidth;
    self.userIcon.layer.cornerRadius = 50 *SMMatchWidth * 0.5;
    self.userIcon.layer.masksToBounds = YES;
    
    self.firstLabel.font = [UIFont systemFontOfSize:9*KMatch];
    self.userName.font = [UIFont systemFontOfSize:9*KMatch];
    self.threeLabel.font = [UIFont systemFontOfSize:9*KMatch];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _listModle.adName;
    
    self.erWeiMa.contentMode = UIViewContentModeScaleAspectFit;
    
    [self setup];
    
    [self setupNav];
    
    [self setupData];
    
}

- (void)setupData{
    
    NSString *imagePath = [self.listModle.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",300 * 2 * SMMatchWidth,368 * 2 * SMMatchHeight]];
    //加载器
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = self.icon.bounds;
    [self.icon addSubview:indicatorView];
    [indicatorView startAnimating];
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"] options:SDWebImageRetryFailed];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [indicatorView stopAnimating];
    }];
    self.userName.text = [NSString stringWithFormat:@"您好!我是您可信赖的朋友—%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserName]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    [self.userIcon setBackgroundImage:image forState:UIControlStateNormal];
    self.userIcon.userInteractionEnabled = NO;
    
    [self setUpErWeiMa];
    
}

- (void)setUpErWeiMa{
    
    NSString *companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *userIdStr = [NSString stringWithFormat:@"scene_str%@",userId];
    //加载器
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = self.erWeiMa.bounds;
    [self.erWeiMa addSubview:indicatorView];
    [indicatorView startAnimating];
    [[SKAPI shared] getWeiXinQrcodeWithCompanyId:companyId userIdStr:userIdStr block:^(id result, NSError *error) {
        if (!error) {
            self.ticket = result;
            //NSString *qrcodeStr = [SKAPI_PREFIX_SHARE stringByAppendingString:[NSString stringWithFormat:@"/weixin/qrcode?ticket=%@",self.ticket]];
            NSString *qrcodeStr = [SKAPI_PREFIX_SHARE stringByAppendingString:[NSString stringWithFormat:@"mall.html?companyId=%@&saleId=%@",companyId,userId]];
            UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrcodeStr] withSize:150];
            
            self.erWeiMa.image = qrcode;
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
    self.shareImage = [self getImage];
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
- (UIImage *)getImage{
    //开启图形上下文
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){//6Plus/6sPlus
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 3.0);
    }else {
        UIGraphicsBeginImageContext(self.view.frame.size);
    }
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










@end
