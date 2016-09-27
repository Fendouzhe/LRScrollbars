//
//  SMValidationMessageViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMValidationMessageViewController.h"

@interface SMValidationMessageViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;


@end

@implementation SMValidationMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    [self setupNav];
    [self.inputField becomeFirstResponder];
}

- (void)setupNav{
    self.title = @"朋友验证";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 40;
    rightBtn.height = 25;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"发送" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputField resignFirstResponder];
}

#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 发送 按钮");
    // 点击发送 验证消息
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        SMLog(@"点击了键盘的完成键  ");
        [self rightBtnClick];
    }
    return YES;
}

@end
