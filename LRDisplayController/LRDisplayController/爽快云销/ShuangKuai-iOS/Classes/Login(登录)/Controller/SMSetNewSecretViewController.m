//
//  SMSetNewSecretViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSetNewSecretViewController.h"
#import "AppDelegate.h"

@interface SMSetNewSecretViewController ()

@property (nonatomic ,strong)UITextField *secretField;

@end

@implementation SMSetNewSecretViewController


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
    self.title = @"设置密码";
}

- (void)setupUI{
    
    CGFloat width = KScreenWidth - 2 * KMarginLeftRight;
    NSNumber *widthNum = [NSNumber numberWithFloat:width];
    
    //输入手机号码的textField
    UITextField *newSecretField = [[UITextField alloc] init];
    //    phoneField.delegate = self;
    [self.view addSubview:newSecretField];
    //    phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    newSecretField.placeholder = @"请输入新密码";
    newSecretField.secureTextEntry = YES;
    [newSecretField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(40);
        make.width.equalTo(widthNum);
        make.height.equalTo(@20);
    }];
    self.secretField = newSecretField;
    
    //输入手机号码下面的横线
    UILabel *phoneUnderLine = [[UILabel alloc] init];
    phoneUnderLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:phoneUnderLine];
    [phoneUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(newSecretField.mas_bottom).with.offset(5);
        make.width.equalTo(widthNum);
        make.height.equalTo(@1);
    }];
    
    //确定按钮
    UIButton *sureBtn = [[UIButton alloc] init];
    [self.view addSubview:sureBtn];
    sureBtn.layer.cornerRadius = SMCornerRadios;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:KRedColorLight];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(phoneUnderLine.mas_bottom).with.offset(30);
        make.width.equalTo(widthNum);
        make.height.equalTo(@40);
    }];
    [sureBtn addTarget:self action:@selector(sureBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 点击事件

- (void)sureBtnDidClick{
    SMLog(@"点击了 确定 按钮");
    if (self.secretField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入至少6位数的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //NSString *oldSecret = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
//        [[SKAPI shared] changePassword:oldSecret andNewPassword:self.secretField.text block:^(id result, NSError *error) {
//            if (error) {
//                SMLog(@"%@",error);
//            }else{
//                SMLog(@"%@",result);
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
        
        [[SKAPI shared] forgetPasswordModify:self.secretField.text block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"%@",result);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                SMLog(@"%@",error);
                [MBProgressHUD showError:error.localizedDescription];
            }
        }];
    }
    
}


@end
