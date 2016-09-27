//
//  SMCreateErWeiMaViewController.m
//  生成二维码
//
//  Created by yuzhongkeji on 15/11/5.
//  Copyright © 2015年 yuzhongkeji. All rights reserved.
//

#import "SMCreateErWeiMaViewController.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
#import "SMGroupChatDetailData.h"
#import "SMGroupChatListData.h"
@interface SMCreateErWeiMaViewController ()



@property (nonatomic ,copy)NSString *qrcodeStr;

@end

@implementation SMCreateErWeiMaViewController

- (void)setupQrcodeWithStr:(NSString *)Str{
    
    self.qrcodeStr = Str;
    
    [self addImageView];
    
    //设置二维码生成后显示的一些属性
    [self setupQrcode];
    
    //添加保存按钮
    [self addBottomLabel];
}

//设置二维码生成后显示的一些属性
- (void)setupQrcode{
    //可以通过设置下面这一部分网址，来控制二维码将来扫描出来是什么内容
//    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:@"18588503168"] withSize:250.0f];
    
    //如果是外界通过方法 - (void)setupQrcodeWithStr:(NSString *)Str； 来创建二维码的话，可以把上面的代码换成下面这一段
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:self.qrcodeStr] withSize:250.0f];
    
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    
    self.qrcodeView.image = customQrcode;
    // set shadow
//    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.qrcodeView.layer.shadowRadius = 2;
//    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.qrcodeView.layer.shadowOpacity = 0.5;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加中间的那个imageVIew 来存放二维码用
    [self addImageView];
    
    //设置二维码生成后显示的一些属性
    [self setupQrcode];
    
    //添加保存按钮
//    [self addSaveBtn];
    //[self addBottomLabel];
    
}

- (void)addBottomLabel{
    
    self.title = @"二维码";
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    if (self.user) {
        bottomLabel.text = @"扫一扫二维码图案，加我为好友";
    }else if(self.roomDetail){
        bottomLabel.text = @"扫一扫二维码图案，加入群聊";
    }
    
    bottomLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.qrcodeView.mas_bottom).with.offset(40);
    }];
    
    SMLog(@"%@",self.user.portrait);
    CGFloat iconHeight = 68*KMatch;
    if (self.user) {
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.user.portrait] placeholderImage:nil completed:nil];
        
        NSNumber *w = [NSNumber numberWithFloat:iconHeight];
        
        iconView.layer.cornerRadius = iconHeight / 2.0;
        iconView.clipsToBounds = YES;
        [self.view addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).with.offset(60);
            make.width.equalTo(w);
            make.height.equalTo(w);
        }];
        
        //名字label
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = self.user.name;
        nameLabel.font = KDefaultFont16Match;
        [self.view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(iconView.mas_bottom).with.offset(15);
        }];

    }else if(self.roomDetail){
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.roomDetail.chatroom.imageUrl] placeholderImage:nil completed:nil];

        NSNumber *w = [NSNumber numberWithFloat:iconHeight];
        
        iconView.layer.cornerRadius = iconHeight / 2.0;
        iconView.clipsToBounds = YES;
        [self.view addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).with.offset(15);
            make.width.equalTo(w);
            make.height.equalTo(w);
        }];
        
        //名字label
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = self.roomDetail.chatroom.roomName;
        nameLabel.font = KDefaultFont16Match;
        [self.view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(iconView.mas_bottom).with.offset(15);
        }];
    }else{
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        //取出照片：
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
        iconView.image = image;
        NSNumber *w = [NSNumber numberWithFloat:iconHeight];
        
        iconView.layer.cornerRadius = iconHeight / 2.0;
        iconView.clipsToBounds = YES;
        [self.view addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).with.offset(60);
            make.width.equalTo(w);
            make.height.equalTo(w);
        }];
        
        //名字label
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        nameLabel.font = KDefaultFont16Match;
        [self.view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(iconView.mas_bottom).with.offset(15);
        }];

    }
    
}



////添加保存按钮
//- (void)addSaveBtn{
//    
//    UIButton *btn = [[UIButton alloc] init];
//    CGFloat width = 100;
//    CGFloat height = 40;
//    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
//    CGFloat y = CGRectGetMaxY(self.qrcodeView.frame) + 30;
//    btn.frame = CGRectMake(x, y, width, height);
//    [self.view addSubview:btn];
//    [btn setBackgroundColor:[UIColor greenColor]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitle:@"保存到相册" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(saveQrcode) forControlEvents:UIControlEventTouchUpInside];
//    
//}
//
////保存二维码到相册
//- (void)saveQrcode{
//    
//    UIImageWriteToSavedPhotosAlbum(self.qrcodeView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//}
//
////判断是否保存成功
//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    
//    if (!error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        SMLog(@"%@",[error description]);
//    }
//    
//}



//添加中间的那个imageVIew 来存放二维码用
- (void)addImageView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *qrcodeView = [[UIImageView alloc] init];
    
    CGFloat width = KScreenWidth - 100;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - width) / 2.0;
    qrcodeView.frame = CGRectMake(x, y, width, width);
    [self.view addSubview:qrcodeView];
    self.qrcodeView = qrcodeView;
//    qrcodeView.backgroundColor = [UIColor yellowColor];
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

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


@end
