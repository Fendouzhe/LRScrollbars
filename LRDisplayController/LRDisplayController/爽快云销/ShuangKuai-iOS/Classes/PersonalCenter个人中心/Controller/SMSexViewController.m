//
//  SMSexViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSexViewController.h"
#import "AppDelegate.h"

@interface SMSexViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (nonatomic ,assign)NSInteger sex;

@end

@implementation SMSexViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"性 别";
    
    [self.inputField becomeFirstResponder];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 40;
    rightBtn.height = 25;
    //        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClick{
    SMLog(@"点击了 保存 按钮");
    if ([self.inputField.text isEqualToString:@"男"]) {
        self.sex = 1;
    }else{
        self.sex = 2;
    }
    NSString *sexStr = [NSString stringWithFormat:@"%zd",self.sex];
    NSDictionary *dict = @{@"gender":sexStr};
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"更改性别 成功");
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:self.inputField.text forKey:KUserSex];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"更改名字 失败");
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
