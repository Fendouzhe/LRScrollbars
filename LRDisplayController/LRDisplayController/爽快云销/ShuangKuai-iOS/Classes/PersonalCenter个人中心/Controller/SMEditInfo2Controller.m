//
//  SMEditInfo2Controller.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEditInfo2Controller.h"
#import "AppDelegate.h"

@interface SMEditInfo2Controller ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation SMEditInfo2Controller

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
    self.title = @"简 介";
    
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

#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 保存 按钮");
    
    NSDictionary *dict = @{@"intro": self.inputField.text};
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"更改性别 成功");
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:self.inputField.text forKey:KUserInfo];
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
