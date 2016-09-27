//
//  SMEditInfoController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEditInfoController.h"
#import "SMPersonInfoCell.h"
#import "SMPersonInfoCell2.h"
#import "SMPersonInfoCell3.h"
#import "SMNameViewController.h"
#import "SMMyCodeViewController.h"
#import "SMEditPhoneNumController.h"
#import "SMEditNumController.h"
#import "SMEditCompanyNameController.h"
#import "SMEditInfo2Controller.h"
#import "SMSexViewController.h"
#import "SMAddressViewController.h"
#import "SMCreateErWeiMaViewController.h"
#import "SMIndustryController.h"
#import "AppDelegate.h"
#import "SMWorkPhoneController.h"


@interface SMEditInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,SMIndustryControllerDelegate,UIActionSheetDelegate>

@property (nonatomic ,strong)UIImage *iconImage;


@end

@implementation SMEditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑个人信息";
    self.view.backgroundColor = KControllerBackGroundColor;
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 8;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        SMPersonInfoCell *cell = [SMPersonInfoCell cellWithTableView:tableView];
        if (self.iconImage) {
            cell.iconView.image = self.iconImage;
        }
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        cell.nameLabel.text = @"名字";
        cell.nameInfoLabel.text = nameStr;
        cell.iconView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSex];
        cell.nameLabel.text = @"性别";
        cell.nameInfoLabel.text = sexStr;
        cell.iconView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }
//        else if (indexPath.section == 0 && indexPath.row == 3){
//        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
//        cell.nameInfoLabel.hidden = YES;
//        cell.nameLabel.text = @"我的二维码";
//        cell.iconView.image = [UIImage imageNamed:@"erweimaHei"];
//        return cell;
//    }
    else if (indexPath.section == 0 && indexPath.row == 3){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
        cell.nameLabel.text = @"手机号码";
        cell.nameInfoLabel.text = phoneStr;
        cell.iconView.hidden = YES;
        cell.arrowheadImageView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *workPhone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserWorkPhone];
        cell.nameLabel.text = @"工作电话";
        cell.nameInfoLabel.text = workPhone;
        cell.iconView.hidden = NO;
//        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 5){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *IndustryStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIndustry];
        cell.nameLabel.text = @"行业";
        cell.nameInfoLabel.text = IndustryStr;
        cell.iconView.hidden = NO;
        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 6){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *companyStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
        cell.nameLabel.text = @"公司";
        cell.nameInfoLabel.text = companyStr;
        cell.iconView.hidden = YES;
        cell.arrowheadImageView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 7){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *infoStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        cell.nameLabel.text = @"简介";
        cell.nameInfoLabel.text = infoStr;
        cell.iconView.hidden = NO;
        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else{
        NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyAddress];;
        SMPersonInfoCell3 *cell = [SMPersonInfoCell3 cellWithTableView:tableView];
        cell.addressLabel.text = addressStr;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 68;
    }else if (indexPath.section == 0){
        CGFloat height;
        if (isIPhone5) {
            height = 44;
        }else if (isIPhone6){
            height = 44 *KMatch6;
        }else if (isIPhone6p){
            height = 44 *KMatch6p;
        }
        return height;
    }else{
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleAlert];
        alert.view.tintColor = KBlackColorLight;
        UIAlertAction *camara = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:camara];
        [alert addAction:library];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        //[self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        SMNameViewController *nameVc = [[SMNameViewController alloc] init];
        [self.navigationController pushViewController:nameVc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2){
//        SMSexViewController *vc = [[SMSexViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        //弹出提示选项
//        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
//        [sheet showInView:nil];
        UIAlertController * alertSheet = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //取消按钮
        UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * manBtn =[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //保存
                [self saveserWith:0+1];
        }];
        UIAlertAction * grilBtn = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //保存
                [self saveserWith:1+1];
        }];
        [alertSheet addAction:cancelBtn];
        [alertSheet addAction:manBtn];
        [alertSheet addAction:grilBtn];
        [self presentViewController:alertSheet animated:YES
                         completion:nil];
        
    }
//    else if (indexPath.section == 0 && indexPath.row == 3){//我的二维码
////        SMMyCodeViewController *codeVc = [[SMMyCodeViewController alloc] init];
////        
////        [self.navigationController pushViewController:codeVc animated:YES];
//        
//        SMCreateErWeiMaViewController *vc = [[SMCreateErWeiMaViewController alloc] init];
//#pragma mark 可在这拿到用户的uuid 拼接成字符串 作为字符串
//        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//        NSString *str = KPrefixPersonInfo;
//        NSString *strCode = [str stringByAppendingString:userID];
//        [vc setupQrcodeWithStr:strCode];
//        SMLog(@"strCode  --  %@",strCode);
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
    else if (indexPath.section == 0 && indexPath.row == 3){  //私人电话
//        SMEditPhoneNumController *editPhoneNumVc = [[SMEditPhoneNumController alloc] init];
//        [self.navigationController pushViewController:editPhoneNumVc animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 4){ //工作电话
        SMWorkPhoneController *vc = [SMWorkPhoneController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 5){
        SMIndustryController *vc = [[SMIndustryController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 6){
//        SMEditCompanyNameController *vc = [[SMEditCompanyNameController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 7){
        SMEditInfo2Controller *vc = [[SMEditInfo2Controller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SMAddressViewController *vc = [[SMAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    //    self.picking = YES;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.iconImage = image;
    [self.tableView reloadData];
    
//    //取：
//    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    UIImage* image = [UIImage imageWithData:imageData];
    
    //新头像上传到服务器
    [[SKAPI shared] updatePortrait:image block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"新头像已上传至服务器%@",result);
            //新头像存到本地
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserIconImageChangeNotification object:nil userInfo:nil];
            
        }else{
            SMLog(@"新头像上传服务器失败error = %@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"网络不给力,图片上传失败,请重试！" preferredStyle:UIAlertControllerStyleAlert];
            alert.view.tintColor = [UIColor redColor];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
            //恢复图片
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
            self.iconImage = [UIImage imageWithData:data];
            [self.tableView reloadData];
        }
    }];
}

- (void)sureBtnDidClick:(NSString *)title{
    
    NSString *Industry = title;
    NSDictionary *dict = @{@"induTag":Industry};
    
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:title forKey:KUserIndustry];
            [self.tableView reloadData];
        }else{
            SMLog(@"更改 失败");
        }
    }];
}



-(void)saveserWith:(NSInteger)sex{
    
     NSString *sexStr = [NSString stringWithFormat:@"%zd",sex];
    NSDictionary *dict = @{@"gender":sexStr};
    
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"更改性别 成功");
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:sex-1?@"女":@"男" forKey:KUserSex];
            [self.tableView reloadData];
            //[self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"更改性别 失败");
        }
    }];
};
@end
