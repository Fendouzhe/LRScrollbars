//
//  SMRegistViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/9.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMRegistViewController.h"
//liyongjie add
#import "SMTabBarViewController.h"
#import "NSString+Hash.h"
#import "UIWindow+Extension.h"
#import "AppDelegate.h"
#import "SMAgreementView.h"

/**
 *  对勾按钮的宽度
 */
#define KRightIconBtnWidth 16
/**
 *  对勾按钮距离上面横线的距离
 */
#define KGouBtnMarginToUpLine 15

@interface SMRegistViewController ()<UITextFieldDelegate,SMAgreementViewDeledate>
/**
 *  输入手机号码的textField
 */
@property (nonatomic ,strong)UITextField *phoneField;

/**
 *  输入验证码的textField
 */
@property (nonatomic ,strong)UITextField *testCodeField;

/**
 *  输入密码的textField
 */
@property (nonatomic ,strong)UITextField *secretField;

@property(nonatomic,strong) NSTimer *timer;

//获取验证码按钮
@property (nonatomic ,strong)UIButton *getNumBtn;

//剩下的时间
@property(nonatomic ,assign)int leftTime;
/**
 *  对勾按钮
 */
@property (nonatomic ,strong)UIButton *rightIconBtn;

/**
 *  验证并注册按钮
 */
@property (nonatomic ,strong)UIButton *testAndRegistBtn;

@property (nonatomic ,strong)SMAgreementView *agreementView;

@property (nonatomic ,strong)UIView *cheatView;

@end

@implementation SMRegistViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的状态
    [self setNavState];
    
    //设置UI
    [self setupUI];
    
}

- (void)setupUI{

    CGFloat width = KScreenWidth - 2 * KMarginLeftRight;
    NSNumber *widthNum = [NSNumber numberWithFloat:width];
    
    //输入手机号码的textField
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.delegate = self;
    [self.view addSubview:phoneField];
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.placeholder = @"请输入手机号码";
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(40);
        make.width.equalTo(widthNum);
        make.height.equalTo(@20);
    }];
    self.phoneField = phoneField;
    
    //输入手机号码下面的横线
    UILabel *phoneUnderLine = [[UILabel alloc] init];
    phoneUnderLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:phoneUnderLine];
    [phoneUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(phoneField.mas_bottom).with.offset(5);
        make.width.equalTo(widthNum);
        make.height.equalTo(@1);
    }];
    
    //输入验证码的field   secretField
    UITextField *testCodeField = [[UITextField alloc] init];
    testCodeField.delegate = self;
    [self.view addSubview:testCodeField];
    testCodeField.returnKeyType = UIReturnKeyNext;
    testCodeField.keyboardType = UIKeyboardTypeNumberPad;
    testCodeField.placeholder = @"请输入验证码";
    [testCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(phoneUnderLine.mas_bottom).with.offset(50);
        make.width.equalTo(widthNum);
        make.height.equalTo(@20);
    }];
    self.testCodeField = testCodeField;
    
    //输入验证码下面的横线
    UILabel *testCodeUnderLine = [[UILabel alloc] init];
    testCodeUnderLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testCodeUnderLine];
    [testCodeUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(testCodeField.mas_bottom).with.offset(5);
        make.width.equalTo(widthNum);
        make.height.equalTo(@1);
    }];
    
    //输入密码的field   secretField
    UITextField *secretField = [[UITextField alloc] init];
    secretField.delegate = self;
    [self.view addSubview:secretField];
    secretField.returnKeyType = UIReturnKeyDone;
    secretField.placeholder = @"请输入密码";
    secretField.secureTextEntry = YES;
    [secretField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(testCodeUnderLine.mas_bottom).with.offset(50);
        make.width.equalTo(widthNum);
        make.height.equalTo(@20);
    }];
    self.secretField = secretField;
    
    //输入密码下面的横线
    UILabel *secretUnderLine = [[UILabel alloc] init];
    secretUnderLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:secretUnderLine];
    [secretUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(secretField.mas_bottom).with.offset(5);
        make.width.equalTo(widthNum);
        make.height.equalTo(@1);
    }];
    
    //对勾按钮
    UIButton *rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //这里后面要添加背景图片的
//    [rightIconBtn setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:rightIconBtn];
    [rightIconBtn setImage:[UIImage imageNamed:@"noSelectImage"] forState:UIControlStateNormal];
    [rightIconBtn setImage:[UIImage imageNamed:@"selectImage"] forState:UIControlStateSelected];
    rightIconBtn.contentMode = UIViewContentModeCenter;
    NSNumber *btnWith = [NSNumber numberWithInt:KRightIconBtnWidth];
    self.rightIconBtn = rightIconBtn;
    rightIconBtn.adjustsImageWhenHighlighted = NO;
    
    [rightIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(secretUnderLine.mas_bottom).with.offset(KGouBtnMarginToUpLine);
        make.left.equalTo(self.view.mas_left).with.offset(KMarginLeftRight);
        make.width.equalTo(btnWith);
        make.height.equalTo(btnWith);
    }];
    [rightIconBtn addTarget:self action:@selector(rightIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //“我已阅读并同意”label
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"我已阅读并同意";
//    label.backgroundColor = [UIColor greenColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(rightIconBtn.mas_right).with.offset(8);
        make.centerY.equalTo(rightIconBtn.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    //“爽快服务协议”button
    UIButton *agreementBtn = [[UIButton alloc] init];
//    [agreementBtn setTitle:@"爽快服务协议" forState:UIControlStateNormal];
    [self.view addSubview:agreementBtn];
    agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"爽快服务协议"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:KRedColorLight range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [agreementBtn setAttributedTitle:str forState:UIControlStateNormal];
//    [agreementBtn setBackgroundColor:[UIColor greenColor]];
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label.mas_right).with.offset(1);
        make.centerY.equalTo(label.mas_centerY);
        make.width.equalTo(@85);
        make.height.equalTo(@20);
    }];
    [agreementBtn addTarget:self action:@selector(agreeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    //验证并注册
    UIButton *testAndRegistBtn = [[UIButton alloc] init];
    [self.view addSubview:testAndRegistBtn];
    [testAndRegistBtn setTitle:@"验证并注册" forState:UIControlStateNormal];
    [testAndRegistBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [testAndRegistBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    testAndRegistBtn.layer.cornerRadius = 4;
    testAndRegistBtn.clipsToBounds = YES;
    //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daohangtiao"]];
    [testAndRegistBtn setBackgroundColor:KRedColorLight];
    self.testAndRegistBtn = testAndRegistBtn;
    [testAndRegistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@270);
        make.height.equalTo(@40);
    }];
    [testAndRegistBtn addTarget:self action:@selector(testAndRegistBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //获取验证码按钮
    UIButton *getNumBtn = [[UIButton alloc] init];
    [self.view addSubview:getNumBtn];
    self.getNumBtn = getNumBtn;
    getNumBtn.layer.cornerRadius = SMCornerRadios;
    getNumBtn.clipsToBounds = YES;
    
    NSMutableAttributedString *getNumStr = [[NSMutableAttributedString alloc] initWithString:@"获取验证码"];
    NSRange GetNumStrRange = {0,[getNumStr length]};
    [getNumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:GetNumStrRange];
    [getNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:GetNumStrRange];
    [getNumBtn setAttributedTitle:getNumStr forState:UIControlStateNormal];
    
    [getNumBtn setBackgroundColor:KRedColorLight];
    [getNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).with.offset(-KMarginLeftRight);
        make.centerY.equalTo(phoneField.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@25);
    }];
    [getNumBtn addTarget:self action:@selector(getNumBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timePass) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _leftTime = 60;
    }
    return _timer;
}

//时间一秒一秒的流逝，按钮的60秒倒计时开始。（定时器回调方法）
- (void)timePass{
    if (self.leftTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self setupBtnState];
        return;
    }
    _leftTime--;
    self.getNumBtn.enabled = NO;
    NSString *timeStr = [NSString stringWithFormat:@"%zd秒后重获",self.leftTime];
    
    NSMutableAttributedString *getNumStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSRange GetNumStrRange = {0,[getNumStr length]};
    [getNumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:GetNumStrRange];
    [getNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:GetNumStrRange];
    [self.getNumBtn setAttributedTitle:getNumStr forState:UIControlStateNormal];
    [self.getNumBtn setTitle:timeStr forState:UIControlStateNormal];
}

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //当号码输入框和验证码输入框同时都有文字输入的时候，验证按钮才能被点击
    self.testAndRegistBtn.enabled = self.phoneField.text.length && self.secretField.text.length && self.testCodeField.text.length && self.testAndRegistBtn.selected;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.testAndRegistBtn.enabled = self.phoneField.text.length && self.secretField.text.length && self.testCodeField.text.length && self.testAndRegistBtn.selected;
}
*/

//秒数减少到0 的时候，就重新设置 button的状态
- (void)setupBtnState{
    
    self.getNumBtn.enabled = YES;
    [self.getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    NSMutableAttributedString *getNumStr = [[NSMutableAttributedString alloc] initWithString:@"获取验证码"];
    NSRange GetNumStrRange = {0,[getNumStr length]};
    [getNumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:GetNumStrRange];
    [getNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:GetNumStrRange];
    [self.getNumBtn setAttributedTitle:getNumStr forState:UIControlStateNormal];
}

- (void)getNumBtnDidClick{
    SMLog(@"点击了 获取验证码 按钮");
    if (self.phoneField.text.length != 11) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        //[self.timer fire];
        [[SKAPI shared] smsRequestVerifyWithPhone:self.phoneField.text block:^(id result, NSError *error) {
            //SMLog(@"status = %@-------%@---error = %@",result,self.phoneField.text,error);
            if (!error) {
                [self.timer fire];
            } else {
                [Utils tip:[NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]];
            }
        }];
    }
}
#pragma mark -- 点击事件
- (void)testAndRegistBtnClick{
    SMLog(@"点击了 登录并注册 按钮");
    
    if (!self.rightIconBtn.selected || self.secretField.text.length <= 0 || self.phoneField.text.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先填完上面的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [MBProgressHUD showSuccess:@"注册成功!"];
        [self login];
    }
}

- (void)login{
    //----------------liyongjie add--------------------
    NSString *phone = self.phoneField.text;
    NSString *verifyCode = self.testCodeField.text;
    NSString *password = self.secretField.text;
    [[SKAPI shared] signUpWithAccount:phone andPassword:password andVerifyCode:verifyCode block:^(User *user, NSError *error) {
        if (!error) {
            SMLog(@"注册并登陆成功");
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window switchRootViewController];
            
//            SMTabBarViewController *tabBarVc = [[SMTabBarViewController alloc] init];
//            [self presentViewController:tabBarVc animated:YES completion:nil];
            
            //存到本地偏好设置里面
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:self.phoneField.text forKey:KUserAccount];
            [defaults setObject:self.secretField.text forKey:KUserSecret];
        } else {
            [Utils tip:[NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]];
        }
    }];
    //------------------------------------------------

}

- (void)agreeBtnDidClick{
    NSLog(@"点击了 “爽快服务协议按钮” ");
    [self userIsSigned];
}

- (void)userIsSigned{
    SMLog(@"userIsSigned");
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //蒙板
    UIView *cheatView = [[UIView alloc] init];
    self.cheatView = cheatView;
    cheatView.frame = window.bounds;
    cheatView.backgroundColor = [UIColor lightGrayColor];
    cheatView.alpha = 0.5;
    [window addSubview:cheatView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
    [cheatView addGestureRecognizer:tap];
    
    //协议
    SMAgreementView *agreementView = [SMAgreementView agreementView];
    self.agreementView = agreementView;
    agreementView.deledate = self;
    [window addSubview:agreementView];
    MJWeakSelf
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.cheatView.mas_top).with.offset(64);
        make.bottom.equalTo(weakSelf.cheatView.mas_bottom).with.offset(-49);
        make.left.equalTo(weakSelf.cheatView.mas_left).with.offset(50);
        make.right.equalTo(weakSelf.cheatView.mas_right).with.offset(-50);
    }];
    //    [agreementView loadWebView];
    
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"sk_xieyi.html" ofType:nil];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [agreementView.webVIew loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
}

- (void)cheatViewTap{
    SMLog(@"点击了 灰色蒙板");
    [self.cheatView removeFromSuperview];
    self.cheatView = nil;
    
    [self.agreementView removeFromSuperview];
    self.agreementView = nil;
}

//点击了对勾按钮
- (void)rightIconBtnClick:(UIButton *)btn{
    SMLog(@"点击了 对勾 按钮");
    btn.selected = !btn.selected;
}

//设置导航栏的状态
- (void)setNavState{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"注   册";

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneField resignFirstResponder];
    [self.testCodeField resignFirstResponder];
    [self.secretField resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneField) {
        if ([string isEqualToString:@"\n"]) {
            [self.testCodeField becomeFirstResponder];
        }
    }else if (textField == self.testCodeField){
        if ([string isEqualToString:@"\n"]) {
            [self.secretField becomeFirstResponder];
        }
    }else if(textField == self.secretField){
        if ([string isEqualToString:@"\n"]) {
            [self.secretField resignFirstResponder];
        }
    }
    return YES;
}

#pragma mark -- SMAgreementViewDeledate
- (void)sureBtnDidClick{
    SMLog(@"sureBtnDidClick   SMAgreementViewDeledate");
    [self cheatViewTap];
    [[SKAPI shared] agreement:^(id result, NSError *error) {
        if (error) {
            SMLog(@"error   %@",error);
        }
    }];
    
}

@end
