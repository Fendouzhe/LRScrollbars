//
//  SMSettingViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSettingViewController.h"
#import "SMSettingCell.h"
#import "SMChangePasswordViewController.h"
#import "Utils.h"
#import "SMAccountSecurityController.h"
#import "SMLoginViewController.h"
#import "SMAboutUsViewController.h"
#import "SMNavigationViewController.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <RongIMKit/RongIMKit.h>
#import <SDWebImageManager.h>
#import "SMProductTool.h"
#import "LocalHotProductTool.h"


@interface SMSettingViewController ()<UIAlertViewDelegate>
/**
 *  是否接收的开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *recieveSwitch;
/**
 *  缓存
 */
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;
/**
 *  上面的灰色view
 */
@property (weak, nonatomic) IBOutlet UIView *grayView1;
/**
 *  下面的灰色view
 */

@property(nonatomic,strong)UIAlertView * alertView;
@end

@implementation SMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    //获取是否已获得通知权限
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        SMLog(@"推送关闭");
        self.recieveSwitch.on = NO;
    }else{
        SMLog(@"推送打开");
        self.recieveSwitch.on = YES;
    }
    

}



- (void)setup{
    self.title = @"设置";
    
    self.signOutBtn.layer.cornerRadius = SMCornerRadios;
    self.signOutBtn.clipsToBounds = YES;
    [self.signOutBtn setBackgroundColor:KRedColorLight];
    self.grayView1.backgroundColor = KControllerBackGroundColor;
}

#pragma mark -- 点击事件
- (IBAction)accountSecurityClick1 {
    [self accountSecurityClick];
}

- (IBAction)accountSecurityClick2 {
    [self accountSecurityClick];
}

- (void)accountSecurityClick{
    SMLog(@"点击了 账户安全");
    
//    SMAccountSecurityController *vc = [[SMAccountSecurityController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    //暂时只有修改登录密码
    SMChangePasswordViewController *vc = [[SMChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)eliminate1:(id)sender {
    [self eliminate];
}

- (IBAction)eliminate2:(id)sender {
    [self eliminate];
}

- (void)eliminate{
    SMLog(@"点击了 清除缓存");
//    NSString * path = [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",NSHomeDirectory()];
    
    self.alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"缓存大小为%@,大侠要清除吗?",self.cacheLabel.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [self.alertView show];
    
}

- (IBAction)aboutUsBtnClick1 {
    [self aboutUsBtnClick];
}

- (IBAction)aboutUsBtnClick2 {
    [self aboutUsBtnClick];
}

- (void)aboutUsBtnClick{
    SMLog(@"点击了 关于我们");
    SMAboutUsViewController *vc = [[SMAboutUsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signOutBtnClick {
    SMLog(@"点击了 退出登录");
    
    //重新写入版本
    NSString *key = @"CFBundleVersion";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];

//    SMShowPrompt(@"正在退出...");
//    [[SKAPI shared] signOut:^(id result, NSError *error) {
//        if (!error) {
//            [HUD hide:YES];
////            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat]; //取消微信登录授权
//            [[RCIM sharedRCIM] disconnect:NO];
//            
////            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserAccount];
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSecret];
////            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
//            
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alert show];
//            
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            SMLoginViewController *vc = [[SMLoginViewController alloc] init];
//            SMNavigationViewController * nav = [[SMNavigationViewController alloc]initWithRootViewController:vc];
//            //[self presentViewController:vc animated:YES completion:nil];
//            window.rootViewController = nav;
//        
//        }else{
//            [HUD hide:YES];
//            [MBProgressHUD showError:@"退出失败,请检查网络!"];
//            SMLog(@"退出帐号 失败 error = %@",error);
//        }
//    }];
    
    [[RCIM sharedRCIM] disconnect:NO];
    
    [self deleteFMDB];
    
    [self deleteCach];
    
    [SMProductTool deleteData:nil];
    [LocalHotProductTool deleteData:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAppLoginBgImage];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAppLoginVideoUrl];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KRefreshToken];
    
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserAccount];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSecret];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
    
    //存头像
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
        //是否已签协议
    //[[NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"KUserIsSigned"];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserTelephoneNum];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserWorkPhone];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserID];
    //保存公司id
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyId];
    //保存公司名字
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyName];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserEngCompanyName];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyAddress];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserName];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUSerComPanyLogoPath];

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSex];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIndustry];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserChatToken];
    ///当前柜台id
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfName];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfBgImage];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SMLoginViewController *vc = [[SMLoginViewController alloc] init];
    SMNavigationViewController * nav = [[SMNavigationViewController alloc]initWithRootViewController:vc];
    window.rootViewController = nav;
  
    
}

- (void)deleteFMDB{  //删除置顶路径的某个指定文件   这里删除的是数据库文件 /Users/yuzhongkeji/Library/Developer/CoreSimulator/Devices/281BCDA2-A81C-4838-BEEE-EC23F6886BF6/data/Containers/Data/Application/E68CEEE1-8617-4ACB-A588-19568AEDB4CB/Documents/my.sqlite
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:filePath error:NULL];
}

- (void)deleteCach{  //删除 指定文件夹下面的所有文件夹 （这里删除的是 图片缓存 cach，这个只能删除次文件夹下的文件夹 ，如果是具体的某个文件 ，删不了，例如 xxx.plist）

    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    SMLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject :nil waitUntilDone : YES ];
}

- ( void )clearCachSuccess{
    SMLog ( @" 清理成功 " );
    
    [MBProgressHUD showSuccess:@"已清除本地缓存数据。"];
    
}

- (IBAction)recieveSwitchClick:(UISwitch *)sender {
    SMLog(@"点击了 是否接收通知开关   目前状态： %zd",sender.on);
    
}

- (IBAction)ideaAction:(UIButton *)sender {
    SMLog(@"意见反馈按钮");
    
    CustomAlertView * alertView = [[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    alertView.retainblock = ^(NSString * text){
        //执行上传代码
        SMLog(@"%@",text);
        if (![text isEqualToString:@"请输入您的意见..."] && ![text isEqualToString:@""]) {
            [[SKAPI shared] writeFeedback:text block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"意见反馈%@",result);
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }
        
    };
    
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"意见反馈" message:@"请输入您的意见,我们将尽力解决" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//        SMLog(@"注意学习");
//        //执行提交代码
//    }];
//    // 创建按钮
//    // 注意取消按钮只能添加一个
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
//        // 点击按钮后的方法直接在这里面写
//        SMLog(@"注意学习");
//    }];
//    
//    [alertController addAction:okAction];
//    [alertController addAction:cancelAction];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"请输入您宝贵的意见";
//        
//    }];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString * path = [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",NSHomeDirectory()];
        
        [self clearCache:path];
        
        [[[SDWebImageManager sharedManager] imageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            CGFloat cacheSize = totalSize/1024/1024;
            self.cacheLabel.text = [NSString stringWithFormat:@"%.2lfM",cacheSize];
        }];

        //self.cacheLabel.text = [NSString stringWithFormat:@"%.2lfM",[self folderSizeAtPath:path]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSString * path = [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",NSHomeDirectory()];
    //self.cacheLabel.text = [NSString stringWithFormat:@"%.2lfM",[self folderSizeAtPath:path]];
    [[[SDWebImageManager sharedManager] imageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        CGFloat cacheSize = totalSize/1024/1024;
        self.cacheLabel.text = [NSString stringWithFormat:@"%.2lfM",cacheSize];
    }];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
    //SDWebImage框架自身计算缓存的实现
        //folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    //[[SDImageCache sharedImageCache] cleanDisk];
}
@end
