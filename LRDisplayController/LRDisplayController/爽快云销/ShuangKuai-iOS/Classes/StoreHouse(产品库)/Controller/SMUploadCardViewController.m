//
//  SMUploadCardViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMUploadCardViewController.h"
#import "SMUploadTableViewCell.h"
#import "SMUploadTableViewCell2.h"
#import "SMUploadTableViewCell3.h"
#import "SMChooseNumViewController.h"
#import "UIImage+watermark.h"

@interface SMUploadCardViewController ()<UITableViewDelegate,UITableViewDataSource,SMUploadTableViewCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property(nullable,strong)UITableView * tableView;

@property (nonatomic ,assign)NSInteger sourceType;

//正面照
@property (nonatomic ,strong)SMUploadTableViewCell *cell1;
// 反面照
@property (nonatomic ,strong)SMUploadTableViewCell *cell2;
//手持照
@property (nonatomic ,strong)SMUploadTableViewCell *cell3;

@property (nonatomic ,assign)NSInteger takePhotoTag;
//判断3张照片是否已经全部上传
@property (nonatomic ,assign)BOOL cell1HasChooseImage;
@property (nonatomic ,assign)BOOL cell2HasChooseImage;
@property (nonatomic ,assign)BOOL cell3HasChooseImage;

@end

@implementation SMUploadCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"上传证件";
    [self createTableView];
}

-(void)createTableView{
    self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMUploadTableViewCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMUploadTableViewCell2" bundle:nil] forCellReuseIdentifier:@"UploadCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMUploadTableViewCell3" bundle:nil] forCellReuseIdentifier:@"UploadCell3"];
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.textLabel.text = @"传照片";
    NSArray * array = @[@"身份证正面:",@"身份证反面:",@"手持身份证正面合照；"];
    NSArray * imageArray = @[@"正面",@"反面",@"美女"];
    
    if (indexPath.row == 0) {
        SMUploadTableViewCell2 * cell  =[tableView dequeueReusableCellWithIdentifier:@"UploadCell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row<4){
        SMUploadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell"];
        cell.titleLabel.text = array[indexPath.row-1];
        cell.bgImageView.image = [UIImage imageNamed:imageArray[indexPath.row-1]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.takePhotoBtn.tag = indexPath.row;
        if (indexPath.row == 1) { //正面照
            self.cell1 = cell;
        }else if (indexPath.row == 2){
            self.cell2 = cell;
        }else if (indexPath.row == 3){
            self.cell3 = cell;
        }
        return cell;
    }else{
        SMUploadTableViewCell3 * cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.certainblock = ^{ //点击 确定按钮的回调
            //调用上传照片接口
            if (!self.cell1HasChooseImage) { //如果没有上传身份证正面
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传身份证正面照片" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else if (!self.cell2HasChooseImage){//如果没有上传身份证反面
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传身份证反面照片" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else if (!self.cell3HasChooseImage){//如果没有上传手持身份证正面合照
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传手持身份证正面合照" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            //如果照片都上传了，就调用接口把照片传到服务器

            [self performSelectorInBackground:@selector(upoadImages) withObject:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        };
        return cell;
    }
    
}

- (void)upoadImages{
    SMLog(@"子线程上传 三张已选好的image");
    
    [[SKAPI shared] uploadPic:self.cell1.bgImageView.image block:^(id result, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)result[@"result"];
            NSString *token = dict[@"token"];
            if ([self.delegate respondsToSelector:@selector(cardFrontUploadSeccess:)]) {
                [self.delegate cardFrontUploadSeccess:token];
            }
            
        }else{
            SMLog(@"身份证正面上传失败   %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，身份证正面上传失败,请重新上传" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }];
    
    [[SKAPI shared] uploadPic:self.cell2.bgImageView.image block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"身份证反面上传成功");
            NSDictionary *dict = (NSDictionary *)result[@"result"];
            NSString *token = dict[@"token"];

            if ([self.delegate respondsToSelector:@selector(cardBackUploadSeccess:)]) {
                [self.delegate cardBackUploadSeccess:token];
            }
        }else{
            SMLog(@"身份证反面上传失败   %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，身份证反面上传失败,请重新上传" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }];
    
    [[SKAPI shared] uploadPic:self.cell3.bgImageView.image block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"手持身份证正面合照上传成功");
            
            NSDictionary *dict = (NSDictionary *)result[@"result"];
            NSString *token = dict[@"token"];
            
            if ([self.delegate respondsToSelector:@selector(cardHandUploadSeccess:)]) {
                [self.delegate cardHandUploadSeccess:token];
            }
            
        }else{
            SMLog(@"手持身份证正面合照上传失败   %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，手持身份证正面合照上传失败,请重新上传" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 227;
    }else if (indexPath.row == 4){
        return 44;
    }
    return 196;
}

#pragma mark -- SMUploadTableViewCellDelegate
- (void)takePhotoBtnDidClick:(UIButton *)btn{
    SMLog(@"点击了  上传证件照片");
    self.takePhotoTag = btn.tag;
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                return;
            case 1: //相机
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2: //相册
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            return;
        } else {
            self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = self.sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        image = [image imageWithStringWaterMark:@"仅限中国电信入网使用" inRect:CGRectMake(20, 20 / 2.0, KScreenWidth, KScreenHeight) color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:100]];
//        image = [image imageWithStringWaterMark:@"仅限中国电信入网使用" atPoint:CGPointMake(20, 20) color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:60]];
        
        SMLog(@"imagePickerController  image %@  ,image.size.width   %f   image.size.height   %f",image,image.size.width,image.size.height);
        
        switch (self.takePhotoTag) {
            case 1:
            {
//                self.cell1.bgImageView.image = [image watermarkImage:@"仅限电信入网使用"];
//                self.cell1.bgImageView.image = [self watermarkImage:image withName:@"仅限电信入网使用"];
//                self.cell1.bgImageView.image = [image imageWithStringWaterMark:@"仅限电信入网使用" atPoint:CGPointMake(0, 0) color:[UIColor blueColor] font:KDefaultFontBig];
                
                self.cell1.bgImageView.image = image;
                self.cell1HasChooseImage = YES;
                break;
            }
            case 2:
            {
//                self.cell2.bgImageView.image = image;
                self.cell2.bgImageView.image = image;
                self.cell2HasChooseImage = YES;
                break;
            }
            case 3:
            {
                self.cell3.bgImageView.image = image;
                self.cell3HasChooseImage = YES;
                break;
            }
            default:
                break;
        }

    }];
}

//-(UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo
//{
//    //get image width and height
//    int w = img.size.width;
//    int h = img.size.height;
//    int logoWidth = logo.size.width;
//    int logoHeight = logo.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//    CGContextDrawImage(context, CGRectMake(w-logoWidth, 0, logoWidth, logoHeight), [logo CGImage]);
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
//    // CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
//}
//
////加图片水印
//-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
//{
//    //上下文的大小
//    int w = img.size.width;
//    int h = img.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建颜色
//    //创建上下文
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);//将img绘至context上下文中
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);//设置颜色
//    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
//    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);//设置字体的大小
//    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);//设置字体绘制的颜色
////    CGContextShowTextAtPoint(context, w/2-strlen(text)*5, h/2, text, strlen(text));//设置字体绘制的位置
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);//创建CGImage
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];//获得添加水印后的图片 
//}
//
////加半透明的水印
//- (UIImage *)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage1
//{
//    UIGraphicsBeginImageContext(useImage.size);
//    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
//    [addImage1 drawInRect:CGRectMake(0, useImage.size.height-addImage1.size.height, addImage1.size.width, addImage1.size.height)];
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return resultingImage;
//}

@end
