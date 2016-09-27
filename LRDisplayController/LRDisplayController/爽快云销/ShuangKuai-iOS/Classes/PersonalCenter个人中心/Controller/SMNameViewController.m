//
//  SMNameViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNameViewController.h"
#import "AppDelegate.h"

@interface SMNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;


@end

@implementation SMNameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    [self setupNav];
    [self.inputField becomeFirstResponder];
}

- (void)setupNav{
    self.title = @"名  字";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 40;
    rightBtn.height = 25;
    //        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
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
    SMLog(@"点击了 保存 按钮");
    
    [[SKAPI shared] editProfile:@{@"name":self.inputField.text} block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"更改名字 成功");
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:self.inputField.text forKey:KUserName];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"更改名字 失败      %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

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
