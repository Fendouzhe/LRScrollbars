//
//  SMDiscountCouponViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscountCouponViewController.h"
#import "SMScanerBtn.h"
#import "SMScannerViewController.h"
#import "SMMakeDiscountDetailViewController.h"
#import "AppDelegate.h"

@interface SMDiscountCouponViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *makeBtn;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property(nonatomic,strong)Coupon * codeCoupon;

@property(nonatomic,strong)UIAlertView * alertView;


@end

@implementation SMDiscountCouponViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNav];
    
    self.makeBtn.layer.cornerRadius = 10;
    self.makeBtn.layer.masksToBounds = YES;
}

-(void)setupNav
{
    self.title = @"优惠券兑换";
    
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scanerBtnDidClick{
    //[self.searchBar resignFirstResponder];
    SMLog(@"点击了 扫描二维码 的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}
- (IBAction)makeAction:(UIButton *)sender {
    SMLog(@"点击了 查询按钮");

    [self.view endEditing:YES];
 
    [self querycode];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//输入的code 查询
-(void)querycode
{
    
    [[SKAPI shared] queryCoupon:self.codeTextField.text block:^(id result, NSError *error) {
        if (!error) {
            if (!result) {
                [self showAlertViewWithMessage:@"没有该优惠码"];
                [self hideAlertView];
            }else
            {
                [self showAlertViewWithMessage:@"正在查询，请稍等..."];
                [self hideAlertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SMMakeDiscountDetailViewController * makeDiscount = [[SMMakeDiscountDetailViewController alloc]initWithNibName:@"SMMakeDiscountDetailViewController" bundle:nil];
                    makeDiscount.coupon = (Coupon *)result;
                    [self.navigationController pushViewController:makeDiscount animated:YES];

                });
            }
        }else
        {
            [self showAlertViewWithMessage:@"请求失败"];
            [self hideAlertView];
            SMLog(@"%@",error);
        }
        [self hideAlertView];
    }];
    
}

-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)hideAlertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    });
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [self querycode];
    }
    
    return YES;
}


@end
