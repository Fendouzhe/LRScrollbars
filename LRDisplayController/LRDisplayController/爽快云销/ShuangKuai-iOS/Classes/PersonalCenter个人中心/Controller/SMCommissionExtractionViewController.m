//
//  SMCommissionExtractionViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommissionExtractionViewController.h"
#import "SMExtractionRecordViewController.h"
#import "SMPasswordInputTopView.h"
#import "SMBoundCardViewController.h"
#import "NSString+Hash.h"
#import "LocalBankCard+CoreDataProperties.h"
#import "AppDelegate.h"

@interface SMCommissionExtractionViewController ()<UITextFieldDelegate,SMPasswordInputTopViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;


@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
/**
 *  银行卡
 */
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;

/**
 *  最下面的field  （为了调出数字键盘而创建的）
 */
@property (nonatomic ,strong)UITextField *bottomField;

/**
 *  装密码黑点的按钮
 */
@property (nonatomic ,strong)NSArray *arrSecretBtns;

/**
 *  输入密码的上面一部分view
 */
@property (nonatomic ,strong)SMPasswordInputTopView *topView;

@property (nonatomic ,assign)CGFloat keyboardHeight;

@property (nonatomic ,assign)CGFloat keyboardY;

@property(nonatomic,strong)BankCard * bankcard;

@end

@implementation SMCommissionExtractionViewController
#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupBtns];
    
    [self setupField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    //获取银行卡
    [self loadbankcard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

#pragma mark -- UIKeyboardWillChangeFrameNotification
-(void)keyboardWillChange:(NSNotification *)note{
    SMLog(@"keyboardWillChange");
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘弹出后或隐藏后的frame
    CGRect keyboardFrame =[userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获得键盘的y值
    self.keyboardY = keyboardFrame.origin.y;
    self.keyboardHeight = keyboardFrame.size.height;
    
    if (self.keyboardY < [UIScreen mainScreen].bounds.size.height && [self.bottomField isFirstResponder]) {
        
        [self.view addSubview:self.topView];
    }
    
}

- (void)setupField{
    //这里进来的时候要设置 placeholder 显示的佣金总额
    //
    self.inputField.placeholder = [NSString stringWithFormat:@"当前佣金总额为%@",self.money];
}

- (void)setupBtns{
    self.nextStepBtn.layer.cornerRadius = SMCornerRadios;
    self.nextStepBtn.clipsToBounds = YES;
    self.nextStepBtn.backgroundColor = KRedColor;
    [self.nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //根据用户绑定的银行卡显示不同的字样
    self.bankLabel.textColor = KRedColor;
}



- (void)setupNav{
    self.title = @"佣金提取";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 55;
    rightBtn.height = 25;
    //        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"提取记录" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.bottomField) {
        //限制 只能输入 6位
        if (self.bottomField.text.length == 6)
            return NO;
    }
    
    if ([string isEqualToString:@"\n"]) {
        [self.inputField resignFirstResponder];
        SMLog(@"点击了键盘的 完成键 ");
    }
    return YES;
}


#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 提取记录 按钮");
    SMExtractionRecordViewController *recordVc = [[SMExtractionRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVc animated:YES];
}

- (void)nextStepBtnClick{
    SMLog(@"点击了  下一步  按钮");

        [self.view addSubview:self.bottomField];
        [self.bottomField becomeFirstResponder];
    
}

#pragma mark -- SMPasswordInputTopViewDelegate
- (void)cancelBtnDidClick{
    SMLog(@"点击了 topView 左上角的 红色取消按钮");
    self.bottomField.text = nil;
    [self.bottomField removeFromSuperview];
    [self.topView removeFromSuperview];
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark -- 懒加载

- (SMPasswordInputTopView *)topView{
    if (_topView == nil) {
        _topView = [SMPasswordInputTopView passwordInputTopView];
        _topView.delegate = self;
        CGFloat height = 190;
        _topView.frame = CGRectMake(0, KScreenHeight -  self.keyboardHeight - height, KScreenWidth, height);
        self.arrSecretBtns = @[_topView.btn1,_topView.btn2,_topView.btn3,_topView.btn4,_topView.btn5,_topView.btn6];
    }
    return _topView;
}

- (UITextField *)bottomField{
    if (_bottomField == nil) {
        _bottomField = [[UITextField alloc] init];
        _bottomField.keyboardType = UIKeyboardTypeNumberPad;
        _bottomField.frame = CGRectMake(20, KScreenHeight - 100, KScreenWidth - 40, 30);
        //        _bottomField.backgroundColor = KControllerBackGroundColor;
        _bottomField.delegate = self;
        _bottomField.borderStyle = UITextBorderStyleNone;
        [_bottomField addTarget:self action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    }
    return _bottomField;
}

- (NSArray *)arrSecretBtns{
    if (_arrSecretBtns == nil) {
        _arrSecretBtns = [NSMutableArray array];
    }
    return _arrSecretBtns;
}

#pragma mark -- textFieldDidChange
- (void)textFieldDidChange:(id)sender{
    SMLog(@"%@", self.bottomField.text);
    
    NSInteger inputCount = self.bottomField.text.length;
    //每输入一个数字，就把一个按钮变成密码黑点背景
    for (UIButton *btn in self.arrSecretBtns) {
        if (btn.tag < inputCount) {
            [btn setImage:[UIImage imageNamed:@"mimahei"] forState:UIControlStateNormal];
        }else{
            [btn setImage:nil forState:UIControlStateNormal];
        }
    }
    
    //判断密码输入的正确性
    //需要与网络比较
    
//    if (self.bottomField.text.length == 6 && ![self.bottomField.text isEqualToString:self.secret] ) {
//        SMLog(@"self.secret     %@",self.secret);
//        SMLog(@"密码不正确  提示重新输入");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        [self prepareToInputAgain];
//    }else if (self.bottomField.text.length == 6 && [self.bottomField.text isEqualToString:self.secret] ){
//        SMLog(@"密码正确 提示提取成功");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提取成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        [self commissionExtractionSuccess];
//    }
    if (self.bottomField.text.length == 6 ) {
        //先进行加密再上传
        NSString * str = [[self.bottomField.text sha1String] md5String];
        SMLog(@"Str = %@",str);
        
        [[SKAPI shared] verifyCommissionPwd:str block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"%@",result);
                if ([result[@"message"] isEqualToString:@"success"]) {
                   
                [self commissionExtractionSuccess];
                }
               
            }else
            {
                SMLog(@"%@",error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [self prepareToInputAgain];
            }
        }];
    }
}

/**
 *  密码输入成功后执行的代码
 */
- (void)commissionExtractionSuccess{
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    self.bottomField.text = nil;
    [self.bottomField removeFromSuperview];
    [self.topView removeFromSuperview];
    
    //密码正确  提取佣金
#pragma mark - 密码
//    [[SKAPI shared] fetchCommission:self.inputField.text.doubleValue andBackCard:self.bankcard.bankCard block:^(id result, NSError *error) {
//        if (!error) {
//            if ([result[@"message"] isEqualToString:@"success"]) {
//                SMLog(@"提取成功");
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提取成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }else
//            {
//                SMLog(@"提取失败");
//            }
//            
//        }else
//        {
//            SMLog(@"%@",error);
//        }
//    }];
    
}
/**
 *  密码输入不正确  准备下一次输入
 */
- (void)prepareToInputAgain{
    //    [self.topView removeFromSuperview];
    //    [self.view addSubview:self.topView];
    self.bottomField.text = nil;
    for (UIButton *btn in self.arrSecretBtns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
}

//获取银行卡
-(void)loadbankcard
{
    NSArray * array = [LocalBankCard MR_findAll];
    self.bankcard = [array firstObject];
    [self refreshUI];
}

#pragma mark - 懒加载
-(BankCard *)bankcard
{
    if (!_bankcard) {
        _bankcard = [BankCard new];
    }
    return _bankcard;
}

-(void)refreshUI
{
//     self.bankLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankcard.bankName,[self.bankcard.bankCard substringWithRange:NSMakeRange(self.bankcard.bankCard.length-4, 4)]];
}


@end
