//
//  takePhoto.m
//  TakePicture
//
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//
/*
 作者：景泰蓝   bug联系QQ：840737320  微信：housenkui
 
  从民国的青帮，到文革的红卫兵，
  再到城市化建设的城管，以及现在软件行业的产品经理，无一不是社会深刻变革的产物。
 
 */
#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#import "takePhoto.h"

@interface takePhoto ()

@property (nonatomic ,strong)UIViewController *vc;

@end

@implementation takePhoto
{
    NSUInteger sourceType;
}

+ (takePhoto *)sharedModel{
    static takePhoto *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePicture:(sendPictureBlock)block{
    
    takePhoto *tP = [takePhoto sharedModel];
    
    tP.sPictureBlock =block;
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
    }

     sheet.tag = 255;
    
//    [sheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    [sheet showInView:AppRootView];
    

}

- (instancetype)initWithVc:(UIViewController *)vc block:(sendPictureBlock)block{
    if (self = [super init]) {
        
        self.vc = vc;
        takePhoto *tP = [takePhoto sharedModel];
        
        tP.sPictureBlock =block;
        
        UIActionSheet *sheet;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
        }
        else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.vc.view];
        
    }
    return self;
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
         sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self.vc presentViewController:imagePickerController animated:YES completion:nil];
        
//        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//        while (topRootViewController.presentedViewController)
//        {
//            topRootViewController = topRootViewController.presentedViewController;
//        }
//        
//        [topRootViewController presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    SMLog(@"didFinishPickingMediaWithInfo");
    takePhoto *TPhoto = [takePhoto sharedModel];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    [TPhoto sPictureBlock](image);
    
}


@end
