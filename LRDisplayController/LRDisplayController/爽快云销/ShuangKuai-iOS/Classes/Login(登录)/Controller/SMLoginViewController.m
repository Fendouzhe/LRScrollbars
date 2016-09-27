//
//  SMLoginViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/9.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SMRegistViewController.h"
#import "SMForgetViewCOntroller.h"
#import "SMTabBarViewController.h"
#import "UIWindow+Extension.h"
#import "AppDelegate.h"
#import <AVIMClient.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>
#import "LocalAd.h"
#import "LocalNews.h"
#import "LocalUser.h"
#import "LocalTweet.h"
#import "LocalUser1.h"
#import "LocalCoupon.h"
#import "LocalCompany.h"
#import "LocalProduct.h"
#import "LocalWorkLog.h"
#import "LocalActivity.h"
#import "LocalBankCard.h"
#import "LocalCustomer.h"
#import "LocalCommission.h"
#import "LocalChatMessage.h"
#import "LocalChatMessageFrame.h"
#import "LocalCommissionLog.h"
#import "LocalConversation.h"
#import "LocalFavorites.h"
#import "LocalFavoritesDetail.h"
#import "LocalOrderProduct.h"
#import "LocalSalesOrder.h"
#import "LocalSchedule.h"
#import "LocalScheduleCompose.h"
#import "LocalSearchHistory.h"
#import "LocaltweetFrame.h"
#import "LocalStorehouse.h"
#import "SingtonManager.h"
#import <ShareSDK/ShareSDK.h>
#import "SMBindPhoneController.h"
#import "SMNavigationViewController.h"
#import <ShareSDK/ShareSDK.h>

#import <RongIMKit/RongIMKit.h>
#import "SMFriendList.h"
#import "WXApi.h"
#import "TaskDetailInfoViewController.h"
#import "SMAVController.h"
#import "SMVideoViewController.h"

#define KBEditPen 32

#define buttonHeight 40*KMatch

@interface SMLoginViewController ()<UITextFieldDelegate,SMBindPhoneControllerDelegate>


/**
 *  爽快图标
 */
@property (nonatomic ,strong)UIImageView *iconView;

/**
 *  键盘自动上下移动时的 间距控制
 */
@property (nonatomic ,assign)CGFloat margin;

@property (nonatomic ,strong)SSDKUser *user;

@property (nonatomic, strong)UIButton *wxLoginBtn;



@end

@implementation SMLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //self.navigationController.navigationBar.backgroundColor  = [UIColor whiteColor];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavWhite"] forBarMetrics:UIBarMetricsDefault];
    
    //记录到控制器
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
//-(void)viewDidDisappear:(BOOL)animated{
////    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (BOOL)isLogin{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret] length];
}

#pragma mark --viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];//KControllerBackGroundColor;
    
    [self setupUI];
    //判断手机型号
    [self judgeModel];
    
    //如果已经注册，就自动登陆
//    if (!self.isOut) {
//        [self autoLogin];
//    }else{
//        self.phoneField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
//        self.secretField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
//    }
//    
//    TaskDetailInfoViewController *vc = [[TaskDetailInfoViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
//自动登录
- (void)autoLogin{
    //从本地拿到存储的帐号密码登陆
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
    
    if (account) {
        self.phoneField.text = account;
    }
    if (secret) {
        self.secretField.text = secret;
    }
    
    SMLog(@"%@    %@ ",account,secret);
    [[SKAPI shared] signInWithAccount:account andPassword:secret andSocial:@"" block:^(User *user, NSError *error) {
        SMShowPrompt(@"正在登录...");
        //SMLog(@"userId = %@   companyName = %@ companyId = %@",user.userid,user.companyName,user.companyId);
        if (error) {//请求失败
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常,请重试!"];
            SMLog(@"signInWithAccount  error  %@",error);
        }else{//请求成功
            [HUD hide:YES];
            SMLog(@"user.workPhone signInWithAccount %@",user.workPhone);
            
            [self saveInfoWithUser:user];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.userid forKey:KUserID];
            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:KUserName];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
            [[NSUserDefaults standardUserDefaults] setObject:self.secretField.text forKey:KUserSecret];
            //存头像
            if (user.portrait) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
                UIImage *image = [UIImage imageWithData:data];
                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            }else{
                UIImage * image = [UIImage imageNamed:@"220"];
                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            }
            
            
            [[NSUserDefaults standardUserDefaults] setObject:self.secretField.text forKey:KUserSecret];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.intro forKey:KUserInfo];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserTelephoneNum];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.address forKey:KUserCompanyAddress];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.induTag forKey:KUserIndustry];
            
//            //是否已签协议
            [[NSUserDefaults standardUserDefaults] setInteger:user.isSigned forKey:@"KUserIsSigned"];
            SMLog(@"user.isSigned   %zd",user.isSigned);
            //存是否为2级
            [[NSUserDefaults standardUserDefaults] setInteger:user.level2 forKey:@"KUserLevel2"];
            SMLog(@"user.level2 %zd",user.level2);
            
            if (user.gender) {
                [[NSUserDefaults standardUserDefaults] setObject:user.gender-1?@"女":@"男" forKey:KUserSex];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"未知性别" forKey:KUserSex];
            }
            SMLog(@"user.userid   %@",user.userid);
            //注册聊天的Client
            AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
           
//            application.client = [[AVIMClient alloc] initWithClientId:user.rtcKey];
//            
//            
//            [application.client openWithCallback:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    SMLog(@"%zd",succeeded);
//                }else{
//                    SMLog(@"%@",error);
//                }
//            }];
            
            if (application.geTuiClientId) {
                [[SKAPI shared] bindClientId:application.geTuiClientId block:^(id result, NSError *error) {
                    if (!error) {
                        SMLog(@"%@",result);
                    }else{
                        SMLog(@"%@",error);
                    }
                }];
            }
            
            if (application.deviceToken) {
                AVInstallation *currentInstallation = [AVInstallation currentInstallation];
                [currentInstallation setDeviceTokenFromData:application.deviceToken];
                [currentInstallation saveInBackground];
            }
            
            
            
            if (self.isOut) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                SMTabBarViewController *tabBarVc = [[SMTabBarViewController alloc] init];
                [self presentViewController:tabBarVc animated:YES completion:nil];
                
//                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
                
//                SMBindPhoneController *vc = [SMBindPhoneController new];
//                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    //SMLog(@"%@",NSHomeDirectory());
}

//判断手机型号
- (void)judgeModel{
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
    
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    CGFloat iconOffTop = 0;
    CGFloat tipOffTop = 0;
    CGFloat phoneFieldOffTop = 0;
    if (isIPhone4) {
        iconOffTop = 30;
        tipOffTop = 20;
        phoneFieldOffTop = 35;
    }else{
        iconOffTop = 50*KMatch;
        tipOffTop = 20*KMatch;
        phoneFieldOffTop = 30*KMatch;
    }
    //创建爽快图标
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.view addSubview:iconView];
    iconView.image = [UIImage imageNamed:@"177"];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(iconOffTop);
        make.width.equalTo(@(60*KMatch));
        make.height.equalTo(@(60*KMatch));
    }];
    
    //创建 卖的爽赚的快Label
    //设置两遍边距，算出控件宽度，并将这歌宽度转换成 NSNumber 类型

    CGFloat width = KScreenWidth - 2 * KMarginLeftRight;
    NSNumber *widthNum = [NSNumber numberWithFloat:width];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [self.view addSubview:textLabel];
    //textLabel.text = @"卖的爽，赚的快，上爽快！";
    textLabel.text = @"让场景云霄无限爽快";
    
    textLabel.font = [UIFont fontWithName:@"JQiTi" size:22];

    //这里需要添加  迷你简启体  字体
//    textLabel.font = [UIFont systemFontOfSize:20];
//    textLabel.font = [UIFont boldSystemFontOfSize:20];
    textLabel.textAlignment = NSTextAlignmentCenter;
//    textLabel.backgroundColor = [UIColor greenColor];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconView.mas_bottom).with.offset(tipOffTop);
        make.width.equalTo(widthNum);
        make.height.equalTo(@28);
    }];
    
    //输入手机号码的textField
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.delegate = self;
    [self.view addSubview:phoneField];
    phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.placeholder = @"请输入手机号码";
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    CGFloat lefViewHeight = 30;
    UIView *phLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lefViewHeight+10, lefViewHeight)];
    UIImageView *phImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"account"] scaleToSize:CGSizeMake(lefViewHeight, lefViewHeight)]];
    phImageView.frame = CGRectMake(10, 0, lefViewHeight, lefViewHeight);
    [phLeftView addSubview:phImageView];
    phoneField.leftView = phLeftView;
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(textLabel.mas_bottom).with.offset(phoneFieldOffTop);
        make.width.equalTo(widthNum);
        make.height.equalTo(@(buttonHeight));
    }];
    self.phoneField = phoneField;

//    //输入手机号码下面的横线
//    UILabel *phoneUnderLine = [[UILabel alloc] init];
//    phoneUnderLine.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:phoneUnderLine];
//    [phoneUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(phoneField.mas_bottom).with.offset(5);
//        make.width.equalTo(widthNum);
//        make.height.equalTo(@1);
//    }];
    
    //输入密码的field   secretField
    UITextField *secretField = [[UITextField alloc] init];
    secretField.delegate = self;
    [self.view addSubview:secretField];
    secretField.returnKeyType = UIReturnKeyDone;
    secretField.placeholder = @"请输入密码";
    secretField.secureTextEntry = YES;
    secretField.clearButtonMode = UITextFieldViewModeWhileEditing;
    secretField.borderStyle = UITextBorderStyleRoundedRect;
    
    UIView *secrLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lefViewHeight+10, lefViewHeight)];
    UIImageView *secrImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"secrect"] scaleToSize:CGSizeMake(lefViewHeight, lefViewHeight)]];
    secrImageView.frame = CGRectMake(10, 0, lefViewHeight, lefViewHeight);
    [secrLeftView addSubview:secrImageView];
    secretField.leftView = secrLeftView;
    secretField.leftViewMode = UITextFieldViewModeAlways;
    
    [secretField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        //make.bottom.equalTo(phoneUnderLine.mas_bottom).with.offset(phoneFieldOffTop);
        make.top.equalTo(phoneField.mas_bottom).with.offset(20);
        make.width.equalTo(widthNum);
        make.height.equalTo(@(buttonHeight));
    }];
    self.secretField = secretField;
    
//    //输入密码下面的横线
//    UILabel *secretUnderLine = [[UILabel alloc] init];
//    secretUnderLine.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:secretUnderLine];
//    [secretUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(secretField.mas_bottom).with.offset(5);
//        make.width.equalTo(widthNum);
//        make.height.equalTo(@1);
//    }];
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"登    录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [loginBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"deepRed"]]];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setBackgroundColor:KRedColorLight];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat margin;
        if (isIPhone4) {
            margin = 40;
        }else{
            margin = 50 *KMatch;
        }
        
        make.centerX.equalTo(self.view.mas_centerX);
        //make.top.equalTo(secretUnderLine.mas_bottom).with.offset(margin);
        make.top.equalTo(secretField.mas_bottom).with.offset(margin);
        make.width.equalTo(widthNum);
        make.height.equalTo(@(buttonHeight));
    }];
    [loginBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //注册和忘记密码中间的竖线
//    UILabel *underMidLine = [[UILabel alloc] init];
//    underMidLine.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:underMidLine];
    
    //注册按钮
    UIButton *registBtn = [[UIButton alloc] init];
    [self.view addSubview:registBtn];
    //registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registBtn setTitle:@"注    册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.layer.cornerRadius = 5;
    registBtn.clipsToBounds = YES;
    [registBtn setBackgroundColor:KBlackColorLight];
    [registBtn addTarget:self action:@selector(registBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat margin;
        if (isIPhone4) {
            margin = 6;
        }else if (isIPhone5) {
            margin = 10;
        }else if (isIPhone6){
            margin = 15 *KMatch6;
        }else if (isIPhone6p){
            margin = 20 *KMatch6p;
        }
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(margin);
        make.width.equalTo(widthNum);
        make.height.equalTo(@(buttonHeight));
    }];
    
    //忘记密码 的按钮
    UIButton *forgetSecretBtn = [[UIButton alloc] init];
    [self.view addSubview:forgetSecretBtn];
    forgetSecretBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetSecretBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetSecretBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [forgetSecretBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    forgetSecretBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14*KMatch];
    [forgetSecretBtn addTarget:self action:@selector(forgeteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetSecretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(secretField.mas_bottom).offset(10);
        make.right.equalTo(secretField.mas_right).with.offset(-10);
        make.width.equalTo(@(60*KMatch));
        make.height.equalTo(@(16*KMatch));
        
    }];
    
    //微信登录按钮
//    if ([WXApi  isWXAppInstalled]) {//如果有微信就显示微信登录按钮
//        SMLog(@"微信安装了");
//        
        CGFloat labelMargin = 10;
        CGFloat labelWidth = (KScreenWidth - 2*labelMargin)/3;
        UILabel *tipLabel = [[UILabel alloc] init];
        [self.view addSubview:tipLabel];
        tipLabel.text = @"使用第三方登录";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        UIColor *color = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:0.7];
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.font = [UIFont systemFontOfSize:13*KMatch];
        CGFloat off = 0;
        if (isIPhone4) {
            off = 10;
        }else {
            off = 30 *KMatch;
        }
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(registBtn.mas_bottom).offset(off);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@20);
            make.width.equalTo(@(labelWidth));
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        [self.view addSubview:leftLine];
        leftLine.backgroundColor = color;
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipLabel.mas_left).offset(-10);
            make.centerY.equalTo(tipLabel.mas_centerY);
            make.height.equalTo(@0.8);
            make.width.equalTo(@(labelWidth-10));
        }];
        
        UIView *rightLine = [[UIView alloc] init];
        [self.view addSubview:rightLine];
        rightLine.backgroundColor = color;
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.centerY.equalTo(tipLabel.mas_centerY);
            make.height.equalTo(@0.8);
            make.width.equalTo(@(labelWidth-10));
        }];
        
        //微信登录按钮
        UIButton *wxLoginBtn = [[UIButton alloc] init];
        [self.view addSubview:wxLoginBtn];
        //[wxLoginBtn setTitle:@"使用微信登录" forState:UIControlStateNormal];
        //[wxLoginBtn setImage:[[UIImage imageNamed:@"weixin"] scaleToHalfSize] forState:UIControlStateNormal];
        [wxLoginBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [wxLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        wxLoginBtn.layer.cornerRadius = 5;
        wxLoginBtn.clipsToBounds = YES;
        //[wxLoginBtn setBackgroundColor:KBlackColorLight];
        [wxLoginBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
        self.wxLoginBtn = wxLoginBtn;
        [wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat margin;
            if (isIPhone4) {
                margin = 6;
            }else {
                margin = 20 *KMatch;
            }
            
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(tipLabel.mas_bottom).with.offset(margin);
            make.width.equalTo(@(buttonHeight));
            make.height.equalTo(@(buttonHeight));
        }];
 
        
//    }else{
//       SMLog(@"没安装微信");
//        //上架时注释掉
//        //中间分割线
////        [underMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
////            
////            make.centerX.equalTo(self.view.mas_centerX);
////            //make.bottom.equalTo(self.view.mas_bottom).with.offset(-35);
////            make.top.equalTo(loginBtn.mas_bottom).with.offset(15);
////            make.width.equalTo(@1);
////            make.height.equalTo(@15);
////        }];
////        //注册按钮
////        [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////            
////            make.centerY.equalTo(underMidLine.mas_centerY);
////            make.right.equalTo(underMidLine.mas_left).with.offset(-20);
////            make.width.equalTo(@40);
////            make.height.equalTo(@15);
////        }];
////        //忘记密码按钮
////        [forgetSecretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////            
////            //make.bottom.equalTo(self.view.mas_bottom).with.offset(-35);
////            make.top.equalTo(underMidLine.mas_top);
////            make.left.equalTo(underMidLine.mas_right).with.offset(20);
////            make.width.equalTo(@80);
////            make.height.equalTo(@15);
////        }];
//        
//    }
    
    self.phoneField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
    self.secretField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
}
#pragma mark -- 微信登录
- (void)wxLogin{
    SMLog(@"点击了 使用微信登录");
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat]; //取消微信登录授权
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             self.user = user;
             SMLog(@"uid=%@",user.uid);
             SMLog(@"user.credential  %@ user.credential.rawData  %@",user.credential,user.credential.rawData[@"openid"]);
             SMLog(@"token=%@",user.credential.token);
             SMLog(@"nickname=%@   ,user.icon %@  user.gender  %zd",user.nickname,user.icon,user.gender);
             
             NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:KOpenID];
             SMLog(@"KOpenID  SSDKResponseStateSuccess %@",openID);
             SMLog(@"user.credential.rawData[@openid]   %@",user.credential.rawData[@"openid"]);
             
             if (openID == nil) { //如果之前没有微信登录过
                 [[NSUserDefaults standardUserDefaults] setObject:user.credential.rawData[@"openid"] forKey:KOpenID];
                 [self wxlogWithUser:user];
             }else if ([openID isEqualToString:user.credential.rawData[@"openid"]]){
                 [self wxlogWithUser:user];
             }else if (![openID isEqualToString:user.credential.rawData[@"openid"]]){ //换了微信帐号
                 
                 [[NSUserDefaults standardUserDefaults] setObject:user.credential.rawData[@"openid"] forKey:KOpenID]; //重置缓存的openID
                 
                 [self wxlogWithUser:user];
//                 SCLAlertView *alert = [[SCLAlertView alloc] init];
//                 alert.showAnimationType = SlideInFromTop;
//                 alert.hideAnimationType = SlideOutToBottom;
//                 
//                 
//                 [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"检测到您更换了微信登录帐号，需要重新获取微信登录授权" closeButtonTitle:nil duration:0];
//                 
//                 SCLButton *sureBtn = [alert addButton:@"确定" actionBlock:^{
//                     
////                    [self wxLogin];
//                     [self wxlogWithUser:user];
//                 }];
//                 sureBtn.backgroundColor = KRedColorLight;
                 
//                 [self wxLogin];
             }
             
             
//             [[SKAPI shared] signInWithAccount:user.credential.rawData[@"openid"] andPassword:user.credential.rawData[@"access_token"] andSocial:@"wechat" block:^(User *user, NSError *error) {
//                 if (!error) {//如果登录成功   就直接跳转到首页
//                     
//                     //登录成功后需要保存的信息和需要做的跳转
//                     [self bindingSuccess:user];
//                     SMLog(@"user  signInWithAccount %@",user);
//                 }else{  //如果登录失败，拦截错误提示，若“账号未绑定”，则跳到绑定手机界面
//                     if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"账号未绑定"]) {
//                         SMBindPhoneController *vc = [SMBindPhoneController new];
//                         vc.openID = self.user.credential.rawData[@"openid"];
//                         vc.accessToken = self.user.credential.rawData[@"access_token"];
//                         vc.user = self.user;
//                         vc.delegate = self;
//                         SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
//                         [self presentViewController:nav animated:YES completion:nil];
//                     }else{  //其他错误
//                         SMLog(@"error   %@",error);
//                     }
//                     SMLog(@"error  signInWithAccount   %@",error);
//                 }
//             }];
         }
         else
         {
             SMLog(@"%@",error);
         }
     }];
}

- (void)wxlogWithUser:(SSDKUser *)user{
    SMShowPrompt(@"正在登录...");
    
    [[SKAPI shared] signInWithAccount:user.credential.rawData[@"openid"] andPassword:user.credential.rawData[@"access_token"] andSocial:@"wechat" block:^(User *user, NSError *error) {
        if (!error) {//如果登录成功   就直接跳转到首页
            [HUD hide:YES];
            //登录成功后需要保存的信息和需要做的跳转
            [self bindingSuccess:user];
            SMLog(@"user  signInWithAccount %@",user);
        }else{  //如果登录失败，拦截错误提示，若“账号未绑定”，则跳到绑定手机界面
            [HUD hide:YES];
            if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"账号未绑定"]) {
                SMBindPhoneController *vc = [SMBindPhoneController new];
                vc.openID = self.user.credential.rawData[@"openid"];
                vc.accessToken = self.user.credential.rawData[@"access_token"];
                vc.user = self.user;
                vc.delegate = self;
                SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }else{  //其他错误
                SMLog(@"error   %@",error);
            }
            SMLog(@"error  signInWithAccount   %@",error);
        }
    }];

}

#pragma mark -- SMBindPhoneControllerDelegate
//登录成功后需要保存的信息和需要做的跳转
- (void)bindingSuccess:(User *)user{
    
    [self saveInfoWithUser:user];
    
    SMTabBarViewController *tabBarVc = [[SMTabBarViewController alloc] init];
    [self presentViewController:tabBarVc animated:NO completion:nil];
}

//登录成功后  通过拿到的user 把user里面的信息都存起来
- (void)saveInfoWithUser:(User *)user{
//    SMLog(@"user.rcToken=%@ userPass = %@",user.rcToken,user.password);
//    SMLog(@"userId = %@   companyName = %@ companyId = %@",user.userid,user.companyName,user.companyId);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount]) {
    
        //已经是登陆过
        if ([self.phoneField.text isEqualToString: [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount]]) {
            //登录的是相同的号，不清空聊天列表
//            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
//            [[NSUserDefaults standardUserDefaults] setObject:self.secretField.text forKey:KUserSecret];
            
        }else{//没有登陆过
            
            [[NSUserDefaults standardUserDefaults] setObject:0 forKey:KCurrenUseSehlfNum];
            
            SMLog(@"删除所有数据");
            
//            AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appdelegate.client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                if (error ) {
//                    SMLog(@"%@",error);
//                }else{
//                    SMLog(@"成=功");
//                }
//            }];
//            
//            appdelegate.client = nil;
            
            //创建新的数据库
//            [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:nil];
//            [NSManagedObjectContext MR_setDefaultContext:nil];
//            [MagicalRecord setupCoreDataStackWithStoreNamed:@"save.sqlite"];
            [self removeSqliteWith:[LocalActivity class]];
            [self removeSqliteWith:[LocalAd class]];
            [self removeSqliteWith:[LocalBankCard class]];
            [self removeSqliteWith:[LocalChatMessage class]];
            [self removeSqliteWith:[LocalChatMessageFrame class]];
            [self removeSqliteWith:[LocalCommissionLog class]];
            [self removeSqliteWith:[LocalConversation class]];
            [self removeSqliteWith:[LocalCoupon class]];
            [self removeSqliteWith:[LocalCustomer class]];
            [self removeSqliteWith:[LocalFavorites class]];
            [self removeSqliteWith:[LocalFavoritesDetail class]];
            [self removeSqliteWith:[LocalNews class]];
            [self removeSqliteWith:[LocalOrderProduct class]];
            [self removeSqliteWith:[LocalProduct class]];
            [self removeSqliteWith:[LocalSalesOrder class]];
            [self removeSqliteWith:[LocalSchedule class]];
            [self removeSqliteWith:[LocalScheduleCompose class]];
            [self removeSqliteWith:[LocalSearchHistory class]];
            [self removeSqliteWith:[LocalStorehouse class]];
            [self removeSqliteWith:[LocalTweet class]];
            [self removeSqliteWith:[LocaltweetFrame class]];
            [self removeSqliteWith:[LocalUser class]];
            [self removeSqliteWith:[LocalUser1 class]];
            [self removeSqliteWith:[LocalWorkLog class]];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
        }
        
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.secretField.text forKey:KUserSecret];
    //存头像
    if (user.portrait) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
        UIImage *image = [UIImage imageWithData:data];
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
        [[NSUserDefaults standardUserDefaults] setObject:user.portrait forKey:KUserPortrait];
    }else{
        UIImage * image = [UIImage imageNamed:@"220"];
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
    }
    
    SMLog(@"user.userid   %@",self.secretField.text);
    //是否已签协议
    [[NSUserDefaults standardUserDefaults] setInteger:user.isSigned forKey:@"KUserIsSigned"];
    
    [[NSUserDefaults standardUserDefaults] setObject:user.intro forKey:KUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserTelephoneNum];
    
    [[NSUserDefaults standardUserDefaults] setObject:user.workPhone forKey:KUserWorkPhone];
    [[NSUserDefaults standardUserDefaults] setObject:user.userid forKey:KUserID];
    SMLog(@"user.workPhone   %@  user.userid  %@",user.workPhone,user.userid);
    //保存公司id
    [[NSUserDefaults standardUserDefaults] setObject:user.companyId forKey:KUserCompanyId];
    //保存公司名字
    [[NSUserDefaults standardUserDefaults] setObject:user.companyName forKey:KUserCompanyName];
    [[NSUserDefaults standardUserDefaults] setObject:user.companyEngName forKey:KUserEngCompanyName];
    [[NSUserDefaults standardUserDefaults] setObject:user.address forKey:KUserCompanyAddress];
    
    [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:KUserName];
    [[NSUserDefaults standardUserDefaults] setObject:user.companyLogoPath forKey:KUSerComPanyLogoPath];
    SMLog(@"user.companyLogoPath   %@",user.companyLogoPath);
    if (user.gender) {
        [[NSUserDefaults standardUserDefaults] setObject:user.gender-1?@"女":@"男" forKey:KUserSex];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"未知性别" forKey:KUserSex];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:user.induTag forKey:KUserIndustry];
    [[NSUserDefaults standardUserDefaults] setObject:user.rcToken forKey:KUserChatToken];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //注册聊天的Client
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    application.client = [[AVIMClient alloc] initWithClientId:user.rtcKey];
//    
//    [application.client openWithCallback:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            SMLog(@"%zd",succeeded);
//        }else{
//            SMLog(@"%@",error);
//        }
//    }];
    
    if (application.geTuiClientId) {
        [[SKAPI shared] bindClientId:application.geTuiClientId block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"哥推连接成功：%@",result);
            }else{
                SMLog(@"哥推连接失败：%@",error);
            }
        }];
    }
    
    if (application.deviceToken) {
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:application.deviceToken];
        [currentInstallation saveInBackground];
    }
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KUserChatToken];
    [[RCIM sharedRCIM] connectWithToken:user.rcToken success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
            [RCIM sharedRCIM].currentUserInfo = userInfo;
            //        [[RCIM sharedRCIM] setUserInfoDataSource:weakSelf];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KUserChatID];
        });
        
        SMLog(@"融云连接成功");
    } error:^(RCConnectErrorCode status) {
        SMLog(@"融云连接错误");
    } tokenIncorrect:^{
        SMLog(@"token错误");
    }];
//    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
//        [[SMFriendList sharedManager] startWithFriendsArray:array];
//    }];

    
}


#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, KScreenWidth, KScreenHeight);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0,KScreenWidth, KScreenHeight);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneField) {
        if ([string isEqualToString:@"\n"]) {
            [self.secretField becomeFirstResponder];
        }
    }else if(textField == self.secretField){
        if ([string isEqualToString:@"\n"]) {
            //[self.secretField resignFirstResponder];
            
            //点了完成，也出发登陆事件
            [self loginBtnDidClick];
        }
    }
    return YES;
}

#pragma mark -- 点击事件
- (void)loginBtnDidClick{
    SMLog(@"点击了登录按钮");
    //这里先要判断  密码是否正确  再登录
    [self.secretField resignFirstResponder];
    SMShowPrompt(@"正在登录...");
    [[SKAPI shared] signInWithAccount:self.phoneField.text andPassword:self.secretField.text andSocial:@"" block:^(id result, NSError *error) {
        
        if (error) {
            SMLog(@"signInWithAccountEror = %@",error);
            [HUD hide:YES];
            //[MBProgressHUD showError:error.localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"帐号或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{//账号密码都正确  登录成功
            [HUD hide:YES];
            //登录的是相同的号，不清空聊天列
            //保存数据，登录融云，哥推等
            User *user = [User mj_objectWithKeyValues:[result valueForKey:@"user"]];
            //SMLog(@"user.userid  signInWithAccount   %@",user.userid);
            [self saveInfoWithUser:user];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.appLoginBg]];
//            UIImage *image = [UIImage imageWithData:data];
//            NSLog(@"result = %@ image = %@  url = %@",result,image,user.appLoginBg);
            if (data) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:KAppLoginBgImage];
            }
            [[NSUserDefaults standardUserDefaults] setObject:user.appLoginVideo forKey:KAppLoginVideoUrl];
            NSLog(@"signInWithAccount result = %@  url = %@",result,user.appLoginVideo);
            
            //accessToken      refreshToken
            NSString *accessToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"accessToken"];
            NSString *refreshToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"refreshToken"];
            //SMLog(@"result  signInWithAccount  %@",result);
            //SMLog(@"signInWithAccount   accessToken  %@   refreshToken  %@",accessToken,refreshToken);
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:KAccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:KRefreshToken];

            //SMLog(@"立马取出来  %@",[[NSUserDefaults standardUserDefaults] objectForKey:KRefreshToken]);
     
            [[SKAPI shared] appendToken];

            //最后清空密码位置。hh
            //self.secretField.text = nil;
            
            
            if (self.isOut) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                ///企业启动图片和视频都没有的话
                if (!user.appLoginVideo && !user.appLoginVideo) {
                    SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }else{
                    //SMAVController *vc = [[SMAVController alloc] init];
                    SMVideoViewController *vc = [[SMVideoViewController alloc] init];
                    vc.bgImageUrlStr = user.appLoginBg;
                    vc.viedeoUrlStr = user.appLoginVideo;
                    //SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
            }
        }

    }];
}

//登录--对外方法--登录融云，哥推等
- (void)login{
    
    //这里先要判断  密码是否正确  再登录
    [[SKAPI shared] signInWithAccount:[[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount] andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret] andSocial:@"" block:^(id result, NSError *error) {
        
        if (error) {
            SMLog(@"signInWithAccountEror = %@",error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"帐号或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{//账号密码都正确  登录成功
            //登录的是相同的号，不清空聊天列
            //保存数据，登录融云，哥推等
            User *user = [User mj_objectWithKeyValues:[result valueForKey:@"user"]];
            SMLog(@"user.userid  signInWithAccount   %@",user.userid);
            [self saveInfoWithUser:user];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.appLoginBg]];
            //            UIImage *image = [UIImage imageWithData:data];
            //            NSLog(@"result = %@ image = %@  url = %@",result,image,user.appLoginBg);
            if (data) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:KAppLoginBgImage];
            }
            [[NSUserDefaults standardUserDefaults] setObject:user.appLoginVideo forKey:KAppLoginVideoUrl];
            
            //accessToken      refreshToken
            NSString *accessToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"accessToken"];
            NSString *refreshToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"refreshToken"];
            SMLog(@"result  signInWithAccount  %@",result);
            SMLog(@"signInWithAccount   accessToken  %@   refreshToken  %@",accessToken,refreshToken);
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:KAccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:KRefreshToken];
            
            SMLog(@"立马取出来  %@",[[NSUserDefaults standardUserDefaults] objectForKey:KRefreshToken]);
            
            [[SKAPI shared] appendToken];
            
        }
        
    }];
}


- (void)registBtnDidClick{
    SMLog(@"点击了注册按钮");
    
    SMRegistViewController *registVc = [[SMRegistViewController alloc] init];
    
    [self.navigationController pushViewController:registVc animated:YES];
   
}

- (void)forgeteBtnDidClick{
    SMLog(@"点击了忘记密码按钮");
    SMForgetViewCOntroller *forgetVc = [[SMForgetViewCOntroller alloc] init];
    [self.navigationController pushViewController:forgetVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneField resignFirstResponder];
    [self.secretField resignFirstResponder];
}

-(void)removeSqliteWith:(Class)modelClass{
    NSArray * array = [modelClass MR_findAll];
    for (id model in array) {
        [model MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)Unread{
    //获取未读
    SingtonManager * sington = [SingtonManager sharedManager];
    //初始化
    [sington initial];
    
    [[SKAPI shared] queryOfflineMessages:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"未读%@",result[@"result"][@"messages"]);
            for (NSDictionary * dic in result[@"result"][@"messages"]) {
                Msg * msg = [Msg mj_objectWithKeyValues:dic];
                if ([dic[@"type"] integerValue] == 30) {
                    [sington.friendArray addObject:msg];
                    sington.friendNum  = sington.friendArray.count;
                }else if([dic[@"type"] integerValue] == 10){
                    [sington.orderArray addObject:msg];
                    sington.orderNum  = sington.orderArray.count;
                }else if ([dic[@"type"] integerValue] == 40){
                    [sington.jobArray addObject:msg];
                    sington.jobNum  = sington.jobArray.count;
                }
            }
            
            //            if (sington.friendNum+sington.orderNum+sington.jobNum>0) {
            //                [self.tabbar.tabBar showBadgeOnItemIndex:3];
            //            }else{
            //                [self.tabbar.tabBar hideBadgeOnItemIndex:3];
            //            }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}

@end
