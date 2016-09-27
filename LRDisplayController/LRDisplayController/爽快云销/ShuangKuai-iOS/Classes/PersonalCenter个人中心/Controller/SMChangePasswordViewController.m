//
//  SMChangePasswordViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMChangePasswordViewController.h"
#import "AppDelegate.h"

#define KBEditPen 32

@interface SMChangePasswordViewController ()<UITextFieldDelegate>
//输入旧密码
@property (weak, nonatomic) IBOutlet UITextField *oldSecretField;
/**
 *  输入新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *inputNewPassword;
/**
 *  再次输入新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *inputNewPasswordAgain;
/**
 *  确认修改
 */
@property (weak, nonatomic) IBOutlet UIButton *sureChangeBtn;

@property (nonatomic ,assign)CGFloat margin;
/**
 *  当前账户
 */
@property (weak, nonatomic) IBOutlet UILabel *currentAccountLabel;


@end

@implementation SMChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.sureChangeBtn.layer.cornerRadius = SMCornerRadios;
    [self.sureChangeBtn setBackgroundColor:KRedColor];
    self.view.backgroundColor = KControllerBackGroundColor;
    
    
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *acountStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
    self.currentAccountLabel.text = [NSString stringWithFormat:@"当前账户：%@",acountStr];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (IBAction)sureChangeBtnClick {
    SMLog(@"点击了 确认修改");
    NSString *oldSecret = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
    
    if ((self.oldSecretField.text.length < 6 || self.oldSecretField.text.length > 16) || (self.inputNewPassword.text.length < 6 || self.inputNewPassword.text.length > 16) || (self.inputNewPasswordAgain.text.length < 6 || self.inputNewPasswordAgain.text.length > 16)) {//密码输入不规范的情况
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确密码（不小于6位，不大于16位）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![self.oldSecretField.text isEqualToString:oldSecret]){//旧密码输入错误的情况
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧密码输入不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.inputNewPassword.text isEqualToString:oldSecret] || [self.inputNewPasswordAgain.text isEqualToString:oldSecret]){//新旧密码一样
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新旧密码不能一样!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![self.inputNewPassword.text isEqualToString:self.inputNewPasswordAgain.text]){//两次密码输入不一样
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次新密码输入不一样" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {//发送更改密码的请求
        [[SKAPI shared] changePassword:self.oldSecretField.text andNewPassword:self.inputNewPassword.text block:^(id result, NSError *error) {
            if (!error) {//请求成功
                SMLog(@"%@",result);
                //将新密码重新存储起来
                [[NSUserDefaults standardUserDefaults] setObject:self.inputNewPassword.text forKey:KUserSecret];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }else{//请求失败
                SMLog(@"%@",error);
            }
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.oldSecretField) {
            [self.inputNewPassword becomeFirstResponder];
        }else if (textField == self.inputNewPassword){
            [self.inputNewPasswordAgain becomeFirstResponder];
        }else if (textField == self.inputNewPasswordAgain){
            [self.view endEditing:YES];
            [self sureChangeBtnClick];
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

@end
