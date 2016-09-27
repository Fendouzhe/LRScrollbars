//
//  SMWorkPhoneController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMWorkPhoneController.h"

@interface SMWorkPhoneController ()

@property (weak, nonatomic) IBOutlet UITextField *inputFiled;


@end

@implementation SMWorkPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改工作电话";
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = KControllerBackGroundColor;
}

- (void)rightItemClick{
    SMLog(@"点击了  保存");
    if ([self.inputFiled.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.showAnimationType = SlideInFromTop;
        alert.hideAnimationType = SlideOutToBottom;
        
        [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"请先输入工作电话" closeButtonTitle:nil duration:2];
        
        SCLButton *sureBtn = [alert addButton:@"确定" actionBlock:^{
            
        }];
        sureBtn.backgroundColor = KRedColorLight;
        return;
    }
    
    [[SKAPI shared] editProfile:@{@"workPhone": self.inputFiled.text} block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            [[NSUserDefaults standardUserDefaults] setObject:self.inputFiled.text forKey:KUserWorkPhone];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}


@end
