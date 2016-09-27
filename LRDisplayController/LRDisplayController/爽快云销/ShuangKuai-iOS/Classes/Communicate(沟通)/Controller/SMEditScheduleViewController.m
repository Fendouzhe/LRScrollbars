//
//  SMEditScheduleViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEditScheduleViewController.h"
#import "AppDelegate.h"

@interface SMEditScheduleViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTitleField;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation SMEditScheduleViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.inputTitleField.delegate = self;
    self.inputTextView.delegate = self;
}

- (void)setupNav{
    self.title = @"编辑日程";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"完成" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    rightBtn.width = 35;
    rightBtn.height = 35;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)rightItemDidClick{
    SMLog(@"点击了右上角的 点点点 按钮");
 
}

#pragma mark -- UITextFieldDelegate,UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [self.inputTitleField resignFirstResponder];
        SMLog(@"点击了标题键盘的 完成键 ");
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self.inputTextView resignFirstResponder];
        SMLog(@"点击了textView键盘的 完成键   %@",self.inputTextView.text);
    }
    return YES;
}


@end
