//
//  SMForgetViewCOntroller.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMForgetViewCOntroller.h"
#import "SMSetNewSecretViewController.h"
#import "AppDelegate.h"
@interface SMForgetViewCOntroller ()<UITextFieldDelegate>

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
//获取验证码按钮
@property (nonatomic ,strong)UIButton *getNumBtn;

//剩下的时间
@property(nonatomic ,assign)int leftTime;

@property(nonatomic,strong) NSTimer *timer;


@end

@implementation SMForgetViewCOntroller


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUI];
    
}

- (void)setupNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"忘记密码";
}

- (void)setupUI{
    
    CGFloat width = KScreenWidth - 2 * KMarginLeftRight;
    NSNumber *widthNum = [NSNumber numberWithFloat:width];
    
    //输入手机号码的textField
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.returnKeyType = UIReturnKeyNext;
        phoneField.delegate = self;
    [self.view addSubview:phoneField];
    //    phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
    testCodeField.returnKeyType = UIReturnKeyDone;
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
    
    //下一步  按钮
    UIButton *nextStepBtn = [[UIButton alloc] init];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepBtn.layer.cornerRadius = SMCornerRadios;
    nextStepBtn.clipsToBounds = YES;
    [nextStepBtn setBackgroundColor:KRedColorLight];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat margin;
        if (isIPhone5) {
            margin = 44;
        }else if (isIPhone6){
            margin = 44 *KMatch6;
        }else if (isIPhone6p){
            margin = 44 *KMatch6p;
        }
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(testCodeUnderLine.mas_bottom).with.offset(margin);
        make.width.equalTo(widthNum);
        make.height.equalTo(@40);
    }];
    [nextStepBtn addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    
    //获取验证码按钮
    UIButton *getNumBtn = [[UIButton alloc] init];
    self.getNumBtn = getNumBtn;
    [self.view addSubview:getNumBtn];
    getNumBtn.layer.cornerRadius = SMCornerRadios;
    getNumBtn.clipsToBounds = YES;
    
    NSMutableAttributedString *getNumStr = [[NSMutableAttributedString alloc] initWithString:@"获取验证码"];
    NSRange GetNumStrRange = {0,[getNumStr length]};
    [getNumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:GetNumStrRange];
    [getNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:GetNumStrRange];
    [getNumBtn setAttributedTitle:getNumStr forState:UIControlStateNormal];

    
//    [getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getNumBtn setBackgroundColor:KRedColorLight];
    [getNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(testCodeUnderLine.mas_top).with.offset(-5);
        make.right.equalTo(self.view.mas_right).with.offset(-KMarginLeftRight);
        make.width.equalTo(@90);
        make.height.equalTo(@25);
    }];
    [getNumBtn addTarget:self action:@selector(getNumBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    

}

#pragma mark -- 定时器60秒衰减代码
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

#pragma mark -- 点击事件
- (void)getNumBtnDidClick{
    SMLog(@"点击了 获取验证码 按钮");
    if (self.phoneField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //[self.timer fire];
    
    [[SKAPI shared] forgetSecretWithPhone:self.phoneField.text block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"获取验证码成功   %@",result);
            [self.timer fire];
        }else{
            //NSString *errorText = error.userInfo[@"NSLocalizedDescription"];
            [MBProgressHUD showError:error.localizedDescription];
            SMLog(@"error===%@",error);
        }
    }];
}

- (void)nextStepClick{
    SMLog(@"点击了 下一步 按钮");
    
    [[SKAPI shared] smsVerifyWithPhone:self.phoneField.text andVefifyCode:self.testCodeField.text block:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:error.localizedDescription];
            SMLog(@"errorText  %@",error);
        }else{
            SMSetNewSecretViewController *setNewVc = [[SMSetNewSecretViewController alloc] init];
            [self.navigationController pushViewController:setNewVc animated:YES];
        }
    }];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneField) {
        if ([string isEqualToString:@"\n"]) {
            [self.testCodeField becomeFirstResponder];
        }
    }else if (textField == self.testCodeField){
        if ([string isEqualToString:@"\n"]) {
            [self.testCodeField resignFirstResponder];
        }
    }
    return YES;
}
@end
