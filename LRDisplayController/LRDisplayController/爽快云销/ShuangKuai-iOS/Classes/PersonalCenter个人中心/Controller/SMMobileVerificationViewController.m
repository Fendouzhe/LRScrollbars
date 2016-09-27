//
//  SMMobileVerificationViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMobileVerificationViewController.h"
#import "SMPasswordInputTopView.h"
#import "SMBottomView.h"
#import "SMCommissionExtractionViewController.h"
#import "AppDelegate.h"
#import "SMBankViewController.h"

#define KBHeight 216
@interface SMMobileVerificationViewController ()<UITextFieldDelegate,SMPasswordInputTopViewDelegate,UIAlertViewDelegate>


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
/**
 *  最下面的field  （为了调出数字键盘而创建的）
 */
@property (nonatomic ,strong)UITextField *bottomField;
/**
 *  装密码黑点的按钮
 */
@property (nonatomic ,strong)NSArray *arrSecretBtns;
/**
 *  输入密码的上面一部分view
 */
@property (nonatomic ,strong)SMPasswordInputTopView *topView;
/**
 *  第一次输入的密码
 */
@property (nonatomic ,copy)NSString *firstSecret;
/**
 *  第二次输入的密码
 */
@property (nonatomic ,copy)NSString *secondSecret;
/**
 *  最终密码
 */
@property (nonatomic ,copy)NSString *secret;
/**
 *  第几次设置密码
 */
@property (nonatomic ,assign)NSInteger inputTimes;
/**
 *  两次密码输入成功之后，显示的成功页面
 */
@property (nonatomic ,strong)SMBottomView *bottomView;

@property (nonatomic ,assign)CGFloat keyboardHeight;

@property (nonatomic ,assign)CGFloat keyboardY;

@property(nonatomic,assign)BOOL isSuccess;

@property(nonatomic,strong)UIAlertView * alertView;

@end

@implementation SMMobileVerificationViewController

#pragma mark -- 懒加载

- (SMPasswordInputTopView *)topView{
    if (_topView == nil) {
        _topView = [SMPasswordInputTopView passwordInputTopView];
        _topView.delegate = self;
        CGFloat height = 190;
        _topView.frame = CGRectMake(0, KScreenHeight -  self.keyboardHeight - height, KScreenWidth, height);
        self.arrSecretBtns = @[_topView.btn1,_topView.btn2,_topView.btn3,_topView.btn4,_topView.btn5,_topView.btn6];
    }
    return _topView;
}
- (SMBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [SMBottomView bottomView];
        _bottomView.frame = CGRectMake(0, KScreenHeight - KBHeight, KScreenWidth, KBHeight);
    }
    return _bottomView;
}

- (NSArray *)arrSecretBtns{
    if (_arrSecretBtns == nil) {
        _arrSecretBtns = [NSMutableArray array];
    }
    return _arrSecretBtns;
}

- (UITextField *)bottomField{
    if (_bottomField == nil) {
        _bottomField = [[UITextField alloc] init];
        _bottomField.keyboardType = UIKeyboardTypeNumberPad;
        _bottomField.frame = CGRectMake(20, KScreenHeight - 100, KScreenWidth - 40, 30);
//        _bottomField.backgroundColor = KControllerBackGroundColor;
        _bottomField.delegate = self;
        _bottomField.borderStyle = UITextBorderStyleNone;
        [_bottomField addTarget:self action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    }
    return _bottomField;
}


#pragma mark --viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
}

- (void)setupNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"手机验证";
    self.view.backgroundColor = KControllerBackGroundColor;
}

- (void)setupUI{
    
    CGFloat width = KScreenWidth - 2 * KMarginLeftRight;
    NSNumber *widthNum = [NSNumber numberWithFloat:width];
    
    //输入手机号码的textField
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.delegate = self;
    [self.view addSubview:phoneField];
//        phoneField.keyboardType = UIKeyboardTypeNumberPad;
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
//    [nextStepBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sousuokuang"]]];
    nextStepBtn.backgroundColor = KRedColorLight;
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(testCodeUnderLine.mas_bottom).with.offset(44);
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
//    [getNumBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"daohangtiao"]]];
    getNumBtn.backgroundColor = KRedColorLight;
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

#pragma mark --  点击事件
- (void)getNumBtnDidClick{
    SMLog(@"点击了 获取验证码 按钮");
    [self.timer fire];
    [self obtainVerify];
    
}

- (void)nextStepClick{
    SMLog(@"点击了 下一步 按钮");
    //这里先要判断，再做跳转
    //验证码校验
    if (![self.phoneField.text isEqualToString:@""]) {
        if (![self.testCodeField.text isEqualToString:@""]) {
            //验证码校验
            [self Verify];
        }else
        {
            [self showAlertViewWithMessage:@"请输入验证码"];
            [self hideAlertView];
        }
    }else
    {
        [self showAlertViewWithMessage:@"请输入手机号"];
        [self hideAlertView];
    }
 
}

#pragma mark -- textFieldDidChange
- (void)textFieldDidChange:(id)sender{
    SMLog(@"%@", self.bottomField.text);
    
    NSInteger inputCount = self.bottomField.text.length;
    for (UIButton *btn in self.arrSecretBtns) {
        if (btn.tag < inputCount) {
            [btn setImage:[UIImage imageNamed:@"mimahei"] forState:UIControlStateNormal];
        }else{
            [btn setImage:nil forState:UIControlStateNormal];
        }
    }
    
    if (inputCount >= 6) {//输入的密码 达到6位
        self.inputTimes += 1;
//        [self performSelector:@selector(removeFieldandTopView) withObject:nil afterDelay:0.6];
        SMLog(@"密码输入完成 做相应的判断操作");
        
        if (self.inputTimes == 1) {
            //第一次输入
            self.topView.titleLabel.text = @"请设置提取佣金密码";
            self.firstSecret = self.bottomField.text;
            [self performSelector:@selector(prepareToSetSecretAgain) withObject:nil afterDelay:0.6];
            
        }else if (self.inputTimes == 2){
            self.inputTimes = 0;
            self.secondSecret = self.bottomField.text;
            SMLog(@"inputTimes == 2");
            if ([self.firstSecret isEqualToString:self.secondSecret]) {
                SMLog(@"两次密码 一样");
                //两次密码输入成功
                self.secret = self.secondSecret;
                [self performSelector:@selector(setSecretSeccess) withObject:nil afterDelay:0.6];
                
            }else{
                SMLog(@"两次密码 不一样");
                //两次密码输入的不一样  ，提示重新输入
 
                self.inputTimes = 0;
                [self performSelector:@selector(resetSecret) withObject:nil afterDelay:0.6];
            }
        }
    }
}
/**
 *  两次密码输入的不一样，重新输入密码
 */
- (void)resetSecret{
    [self.topView removeFromSuperview];
    [self.view addSubview:self.topView];
    self.topView.titleLabel.text = @"请设置提取佣金密码";
    self.bottomField.text = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一样，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
}
/**
 *  两次密码输入一样后，执行的代码  成功跳转界面
 */
- (void)setSecretSeccess{
    self.topView.titleLabel.text = @"密码设置成功";
    [self.bottomField removeFromSuperview];
    [self.view addSubview:self.bottomView];
    SMLog(@"%@",self.secret);
    
    //绑定成功。。。
    [self boundCard];
}
/**
 *  第一次输入完成，准备第二次输入
 */
- (void)prepareToSetSecretAgain{
    
    [self.topView removeFromSuperview];
    [self.view addSubview:self.topView];
    self.topView.titleLabel.text = @"请再输入一次";
    self.bottomField.text = nil;
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
}


/**
 *  用来监听键盘的弹出/隐藏
 */
-(void)keyboardWillChange:(NSNotification *)note{
    
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘弹出后或隐藏后的frame
    CGRect keyboardFrame =[userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 获得键盘的y值
    self.keyboardY = keyboardFrame.origin.y;
    self.keyboardHeight = keyboardFrame.size.height;

    if (self.keyboardY < [UIScreen mainScreen].bounds.size.height && [self.bottomField isFirstResponder]) {

        [self.view addSubview:self.topView];
    }
    
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.bottomField) {
        //限制 只能输入 6位
        if (self.bottomField.text.length == 6)
        return NO;
    }
    
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.inputTimes = 0;
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    [self.view endEditing:YES];
}

#pragma mark -- SMPasswordInputTopViewDelegate
- (void)cancelBtnDidClick{
    SMLog(@"点击了 topView 左边的红色取消按钮");
    self.inputTimes = 0;
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    
    [self.topView removeFromSuperview];
    self.bottomField.text = nil;
    [self.bottomField removeFromSuperview];
    [self.bottomView removeFromSuperview];
    
}

#pragma mark - 获取验证码
-(void)obtainVerify{

    [[SKAPI shared] forgetSecretWithPhone:self.phoneField.text block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  forgetSecretWithPhone  %@ ",result);
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

-(void)Verify
{
    [[SKAPI shared] smsVerifyWithPhone:self.phoneField.text andVefifyCode:self.testCodeField.text block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"验证码输入result%@",result);
            if ([result[@"message"] isEqualToString:@"success"]) {
                self.isSuccess = YES;
                if (self.isSuccess) {
                    //弹出输入密码
                    //[self.view addSubview:self.bottomField];
                    //[self.bottomField becomeFirstResponder];
                    [self boundCard];
                }else
                {
                    [self showAlertViewWithMessage:@"验证码 输入有误"];
                    [self hideAlertView];
                }
            }else
            {
                self.isSuccess = NO;
            }
        }else
        {
            SMLog(@"%@",error);
            self.isSuccess = NO;
            
            if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"验证码不正确"]) {
                [self showAlertViewWithMessage:@"验证码不正确"];
                [self hideAlertView];
            }
        }
    }];
}

-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)hideAlertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    });
    
}

#pragma mark - 绑定银行卡
-(void)boundCard
{
    SMLog(@"self.subBank   %@",self.subBank);
    [[SKAPI shared] bindCard:self.cardNum andIdCard:self.idCareNum andName:self.cardName andSubBank:self.subBank type:1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"boundCardresult%@",result);
            if ([result[@"message"] isEqualToString:@"success"]) {
                self.isSuccess = YES;
                if (self.isSuccess) {
                    //                    SMCommissionExtractionViewController *vc = [[SMCommissionExtractionViewController alloc] init];
                    //                    vc.secret = self.secret;
                    //                    [self.navigationController pushViewController:vc animated:YES];
                    //绑定成功之后  跳转到显示银行卡的界面
                    //SMBankViewController *bankVc = [[SMBankViewController alloc] init];
                    //[self.navigationController pushViewController:bankVc animated:YES];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"绑定成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                }else
                {
                    [self showAlertViewWithMessage:@"网络出错，请检测网络，重新绑定"];
                    [self hideAlertView];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else
            {
                self.isSuccess = NO;
            }
        }else
        {
            SMLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
            
            if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"该银行卡已绑定"]) {
                [self showAlertViewWithMessage:@"该银行卡已绑定"];
                [self hideAlertView];
            }
            self.isSuccess = NO;
        }
 
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [self.navigationController popToViewController:appdelegate.boundCardVC animated:YES];
    }
}

@end
