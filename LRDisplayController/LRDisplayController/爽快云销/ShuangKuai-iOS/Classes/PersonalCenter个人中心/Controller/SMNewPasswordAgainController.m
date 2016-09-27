//
//  SMNewPasswordAgainController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewPasswordAgainController.h"
#import "NSString+Hash.h"
#import "AppDelegate.h"

@interface SMNewPasswordAgainController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (nonatomic ,strong)NSArray *arrBtns;
@end

@implementation SMNewPasswordAgainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"再次输入";
    self.arrBtns = @[self.btn1,self.btn2,self.btn3,self.btn4,self.btn5,self.btn6];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    [self.inputField becomeFirstResponder];
    [self.inputField addTarget:self action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    SMLog(@"%@",self.firstSecret);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
#pragma mark -- textFieldDidChange
- (void)textFieldDidChange:(id)sender{
    SMLog(@"%@", self.inputField.text);
    
    NSInteger inputCount = self.inputField.text.length;
    for (UIButton *btn in self.arrBtns) {
        if (btn.tag <= inputCount) {
            [btn setImage:[UIImage imageNamed:@"mimahei"] forState:UIControlStateNormal];
        }else{
            [btn setImage:nil forState:UIControlStateNormal];
        }
    }
    
#pragma warning   当密码输入了6位之后，这边需要先判断两次密码是否一样，再做  跳转。如果不正确，可考虑去返回到上一页重新输入密码
    if (self.inputField.text.length == 6) {//输入了6位
        NSString *secondSecret = self.inputField.text;
        SMLog(@"%@        %@",self.firstSecret,secondSecret);
        if ([self.firstSecret isEqualToString:secondSecret]) {//两次密码一样
            //MD5加密
            NSString *MD5Str = self.firstSecret.md5String;
            //存放在本地
            [[NSUserDefaults standardUserDefaults] setObject:MD5Str forKey:KUserPaySecret];
            [self requestnetWithSecret:self.firstSecret];
            [self.inputField resignFirstResponder];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } 
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制 只能输入 6位
    if (self.inputField.text.length == 6){
        return NO;
    }
    return YES;
}

-(void)requestnetWithSecret:(NSString *)secret
{
    //先加密
    NSString * str = [[secret sha1String] md5String];
    
    [[SKAPI shared] modifyCommissionPwd:str block:^(id result, NSError *error) {
        if (!error) {
             [self.inputField resignFirstResponder];
            if ([result[@"message"] isEqualToString:@"success"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
                [alert show];
                
                
            }
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });    }
}

@end
