//
//  SMAddContactPersonViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddContactPersonViewController.h"
#import "SMAdressBookViewController.h"
#import "SMScannerViewController.h"
#import "AppDelegate.h"
#import "SMCreateErWeiMaViewController.h"
#import "SMSearchViewController.h"


@interface SMAddContactPersonViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

//我的二维码父试图View
@property (weak, nonatomic) IBOutlet UIView *myCodeView;

/**
 *  我的二维码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *myCodeBtn;

/**
 *  扫一扫view
 */
@property (weak, nonatomic) IBOutlet UIView *scanView;
/**
 *  添加联系人view
 */
@property (weak, nonatomic) IBOutlet UIView *addContactView;
//搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIView *grayView1;

@property (weak, nonatomic) IBOutlet UIView *grayView2;

@property (weak, nonatomic) IBOutlet UIView *grayView3;

@end

@implementation SMAddContactPersonViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self addTapGesture];
}

- (void)addTapGesture{
    UITapGestureRecognizer *tapScan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScanClick)];
    [self.scanView addGestureRecognizer:tapScan];
    
    UITapGestureRecognizer *tapContact = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactClick)];
    [self.addContactView addGestureRecognizer:tapContact];
}

- (void)tapContactClick{
    SMLog(@"点击了 添加手机联系人 那一行view");
    SMAdressBookViewController *adressBookVc = [[SMAdressBookViewController alloc] init];
    [self.navigationController pushViewController:adressBookVc animated:YES];
}

- (void)tapScanClick{
    SMLog(@"点击了 扫一扫 那一行view");
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setup{
    self.view.backgroundColor = KControllerBackGroundColor;
    self.topView.backgroundColor = KControllerBackGroundColor;
    self.myCodeView.backgroundColor = KControllerBackGroundColor;
    self.title = @"添加朋友";
    self.searchField.delegate = self;
    self.searchField.enablesReturnKeyAutomatically = YES;
    
    //放大镜
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"fangdajing2"];
    searchIcon.width = 28;
    searchIcon.height = 28;
    searchIcon.contentMode = UIViewContentModeCenter;
    
    self.searchField.leftView =searchIcon;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //设置下颜色
    self.grayView1.backgroundColor = KControllerBackGroundColor;
    self.grayView2.backgroundColor = KControllerBackGroundColor;
    self.grayView3.backgroundColor = KControllerBackGroundColor;
    
    self.searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchField resignFirstResponder];
}

//#pragma mark -- UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if ([string isEqualToString:@"\n"]) {
//        [self.searchField resignFirstResponder];
//        SMLog(@"点击了 键盘的搜索键 ，执行搜索代码");
//    }
//    return YES;
//}

- (IBAction)myCodeBtnClick {
    
    SMLog(@"点击了 我的二维码 按钮");
    SMCreateErWeiMaViewController *vc = [[SMCreateErWeiMaViewController alloc] init];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    [vc setupQrcodeWithStr:[NSString stringWithFormat:@"SK-PROFILE:%@",userId]];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)searchBtnClick {
    SMLog(@"点击了 搜索按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 8;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
