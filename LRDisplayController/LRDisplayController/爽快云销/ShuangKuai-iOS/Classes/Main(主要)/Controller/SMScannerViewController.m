//
//  SMScannerViewController.m
//  二维码扫描封装成一个控制器00
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 yuzhongkeji. All rights reserved.
//

#import "SMScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SMScannerJumpViewController.h"
#import "SMPersonInfoViewController.h"
#import "SMMakeDiscountDetailViewController.h"
#import "SMActivieSignWebController.h"

#define ScannerTop 120
#define ScannerSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?500:220)
#define ScannerBGFixed (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?50:30)
#define ResultButtonHeight 40

@interface SMScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

{
    AVCaptureDevice * device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    UIImageView *scannerBGView;
    
    UIImageView *line;
    int num;
    BOOL upOrdown;
    NSTimer *timer;
    
    UITextView *resultTextView;
    
    UIButton *scanButton;
}

@end

@implementation SMScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //iOS如何判断应用是否开启摄像头权限
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {//如果没有权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置中允许爽快访问您的相机权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{//如果有权限
        
        [self buildUI];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startScan];
        });
        //[self startScan];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self startScan];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)buildUI{
    self.title = @"扫描二维码";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = KControllerBackGroundColor;
    
    //背景方框
    scannerBGView = [[UIImageView alloc] init];
    scannerBGView.frame =  CGRectMake((self.view.bounds.size.width-ScannerSize)*0.5-ScannerBGFixed,
                                      ScannerTop-ScannerBGFixed,
                                      ScannerSize+ScannerBGFixed*2,
                                      ScannerSize+ScannerBGFixed*2);
    scannerBGView.image = [UIImage imageNamed:@"bg_scanner"];
    [self.view addSubview:scannerBGView];
    
    //上线走动的横线
    upOrdown = NO;
    num =0;
    line = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-ScannerSize)*0.5-ScannerBGFixed, ScannerTop, ScannerSize+ScannerBGFixed*2, 1)];
    line.backgroundColor = [UIColor greenColor];
    line.layer.cornerRadius = 8;
    [self.view addSubview:line];
    //上线走动的横线 执行动画
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    
    //开始扫描按钮
    scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(20,
                                  self.view.bounds.size.height - 150,
                                  self.view.bounds.size.width-20*2,
                                  ResultButtonHeight);
    scanButton.backgroundColor = KRedColor;
    [scanButton setTitle:@"开 始 扫 描" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:scanButton];
    
    [scanButton addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scanAnimation{
    if (upOrdown == NO) {
        num ++;
        line.frame = CGRectMake((KScreenWidth-ScannerSize)*0.5-ScannerBGFixed,
                                ScannerTop+2*num,
                                ScannerSize+ScannerBGFixed*2,
                                1);
        if (2*num >= ScannerSize) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        line.frame = CGRectMake((self.view.bounds.size.width-ScannerSize)*0.5-ScannerBGFixed,
                                ScannerTop+2*num,
                                ScannerSize+ScannerBGFixed*2,
                                1);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera{
//    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    // Device
    if (!device) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    // Input
    if (!input) {
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    
    // Output
    if (!output) {
        output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    
    // Session
    if (!session) {
        session = [[AVCaptureSession alloc]init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    if (!preview) {
        preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        preview.frame = CGRectMake((self.view.bounds.size.width-ScannerSize)*0.5,
                                   ScannerTop,
                                   ScannerSize,
                                   ScannerSize);
        [self.view.layer insertSublayer:preview atIndex:0];
    }
    
    
    // Start
    resultTextView.text = @"";
    if (!timer.isValid) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    }
    
    [session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [session stopRunning];
    
    [timer invalidate];
    
    #pragma mark -- 拿到了二维码的扫描结果，在这里做事情
    
//    NSString *str = @"SK-PROFILE:5bf4e880-66a8-45e8-921b-0ae54d1737ea";
//    NSArray *arr = [str componentsSeparatedByString:@":"];
//    SMLog(@"%@ ----%@",arr.firstObject,arr.lastObject);
    SMLog(@"二维码扫描结果 stringValue  %@",stringValue);
    
    //扫描结果的前半部分字符串
    NSArray *strArr = [stringValue componentsSeparatedByString:@":"];
    NSString *headStr = [strArr firstObject];
    if ([headStr isEqualToString:@"http"] || [headStr isEqualToString:@"ftp"] || [headStr isEqualToString:@"https"]||[headStr.uppercaseString isEqualToString:@"WWW."]) {//网页
        SMScannerJumpViewController *vc = [[SMScannerJumpViewController alloc] init];
        vc.urlStr = stringValue;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([headStr isEqualToString:@"SK-PROFILE"]){//个人信息
        SMLog(@"扫描到了 个人信息");
        //拿到扫描结果的后半部分字符串,就是个人信息的uuid 了
        NSString *footStr = [strArr lastObject];
        [[SKAPI shared] queryUserProfile:footStr block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result   queryUserProfile   %@",result);
                SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
                vc.user = (User *)result;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                SMLog(@"error   %@",error);
            }
        }];
        
    }else if ([headStr isEqualToString:@"SK-COUPON"]){//优惠券
        //拿到扫描结果的后半部分字符串,就是优惠券的使用码 了
        NSString *footStr = [strArr lastObject];
        SMMakeDiscountDetailViewController *vc = [[SMMakeDiscountDetailViewController alloc] init];
        vc.codeNum = footStr;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([headStr isEqualToString:@"SK-REGISTRATION_EVENT"]){
        NSString *footStr = [strArr lastObject];
        NSArray *idArr = [footStr componentsSeparatedByString:@"/"];
        SMActivieSignWebController *vc =[[SMActivieSignWebController alloc] init];
        vc.eid = [idArr firstObject];
        vc.sn = [idArr lastObject];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)startScan{
    [self setupCamera];
}

@end
