//
//  SMAccountSecurityController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//  账户安全

#import "SMAccountSecurityController.h"
#import "SMChangePasswordViewController.h"
#import "SMNewPasswordController.h"
#import "SMForgetPayViewCOntroller.h"
#import "AppDelegate.h"

@interface SMAccountSecurityController ()

@end

@implementation SMAccountSecurityController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"账户安全";
}

- (IBAction)changeLoginSecretClick1 {
    [self changeLoginSecretClick];
}

- (IBAction)changeLoginSecretClick2 {
    [self changeLoginSecretClick];
}

- (void)changeLoginSecretClick{
    SMLog(@"点击了 修改登录密码");
    
    SMChangePasswordViewController *vc = [[SMChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)resetSecretClick1 {
    [self resetSecretClick];
}

- (IBAction)resetSecretClick2 {
    [self resetSecretClick];
}

- (void)resetSecretClick{
    SMLog(@"点击了重置 支付密码");
    SMForgetPayViewCOntroller *vc = [[SMForgetPayViewCOntroller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
