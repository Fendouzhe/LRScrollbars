//
//  SMNewPasswordController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewPasswordController.h"
#import "SMNewPasswordAgainController.h"
#import "AppDelegate.h"
@interface SMNewPasswordController ()<UITextFieldDelegate>
/**
 *  输入栏，这里只是为了唤醒数字键盘，把它设置成看不到的状态
 */
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;
/**
 *  装6个按钮的数组
 */
@property (nonatomic ,strong)NSArray *arrBtns;

@end

@implementation SMNewPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self.inputField addTarget:self action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    
    self.arrBtns = @[self.btn1,self.btn2,self.btn3,self.btn4,self.btn5,self.btn6];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputField becomeFirstResponder];
    
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

#pragma warning   当密码输入了6位之后，就判断旧密码是否正确  self.inputField.text 与客户密码进行比较,正确才做跳转
    if (self.inputField.text.length == 6) {
        SMNewPasswordAgainController *vc = [[SMNewPasswordAgainController alloc] init];
        vc.firstSecret = self.inputField.text;
        self.inputField.text = nil;
        for (UIButton *btn in self.arrBtns) {
            [btn setImage:nil forState:UIControlStateNormal];
        }
        [self.navigationController pushViewController:vc animated:YES];
        
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

    
@end
