//
//  SMFriendVerificationController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMFriendVerificationController.h"

@interface SMFriendVerificationController ()

@property (weak, nonatomic) IBOutlet UIView *topGrayView;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation SMFriendVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    
}

- (void)setupNav{
    
    self.title = @"朋友验证";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    dict[NSFontAttributeName] = KDefaultFontBig;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发送" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = KControllerBackGroundColor;
    self.topGrayView.backgroundColor = KControllerBackGroundColor;
}

- (void)rightBtnClick{
    SMLog(@"点击了 发送 ");
}

@end
