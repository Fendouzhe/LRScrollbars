//
//  SMNewCustomerViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewCustomerViewController.h"
#import "SMCreatNewCustomerView.h"
#import "SMCustomerStateTableViewController.h"
#import "SMCustomerLevelTableViewController.h"

#import "LocalCustomer+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"

#define KBEditPen 32
@interface SMNewCustomerViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *oneIntervalView;

@property (weak, nonatomic) IBOutlet UIView *twoIntervalView;

@property (weak, nonatomic) IBOutlet UIView *threeIntervalView;

/**
 *  添加更多电话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addMorePhoneNumBtn;

/**
 *  选择客户状态按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCustomerStateBtn;
/**
 *  选择客户级别按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCustomerLevelBtn;
/**
 *  原有的联系电话view
 */
@property (weak, nonatomic) IBOutlet UIView *originalPhoneNumView;
/**
 *  添加更多电话的那一小个整体试图
 */
@property (weak, nonatomic) IBOutlet UIView *addMoreNumView;
/**
 *  电话那两行的整体view
 */
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
/**
 *  联系电话部分一行的高度
 */
@property (nonatomic ,assign)CGFloat marginRow;

/**
 *  键盘自动上下移动时的 间距控制
 */
@property (nonatomic ,assign)CGFloat margin;

/**
 *  以下是输入内容
 */
//简称
@property (weak, nonatomic) IBOutlet UITextField *abbreviationTextField;
//全称
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
//客户编号
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
//客户地址
@property (weak, nonatomic) IBOutlet UITextField *adressTextField;
//网址
@property (weak, nonatomic) IBOutlet UITextField *webTextField;
//介绍
@property (weak, nonatomic) IBOutlet UITextField *introduceTextfield;
//联系电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
//更多联系电话
@property(nonatomic,assign)NSInteger  state;
@property(nonatomic,assign)NSInteger  lever;

@property(nonatomic,copy)NSArray * stateArray;
@property(nonatomic,copy)NSArray * levelArray;

@property(nonatomic,strong)UIAlertView * alertView;

@property (weak, nonatomic) IBOutlet UIView *fiestSecsion;


@end

@implementation SMNewCustomerViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupColor];
    
    [self setupNav];
    
    [self setup];
    
    //设置键盘自动弹起
    [self setupTextFields];
    
    self.fiestSecsion.backgroundColor = KControllerBackGroundColor;
    self.addMorePhoneNumBtn.hidden = YES;
 
}

- (void)setupTextFields{
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = [textField convertRect:textField.bounds toView:self.view];
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setupNav{
    self.title = @"新建客户";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    dict[NSFontAttributeName] = KDefaultFontBig;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    rightBtn.width = 40;
    rightBtn.height = 26;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setup{
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
}

- (void)setupColor{
    
    self.oneIntervalView.backgroundColor = KControllerBackGroundColor;
    self.twoIntervalView.backgroundColor = KControllerBackGroundColor;
    self.threeIntervalView.backgroundColor = KControllerBackGroundColor;
    self.view.backgroundColor = KControllerBackGroundColor;
}

#pragma mark -- 点击事件
- (void)rightItemDidClick{
    SMLog(@"点击了 创建 按钮");
    
    //进行判断，并给出相应提示
    if (![self.abbreviationTextField.text isEqualToString:@""]) {
        if (![self.fullNameField.text isEqualToString:@""]) {
            if (![self.idTextField.text isEqualToString:@""]) {
                if (![self.phoneTextfield.text isEqualToString:@""]) {
                    if (![self.chooseCustomerStateBtn.titleLabel.text isEqualToString:@"请选择客户状态"]) {
                        if (![self.chooseCustomerLevelBtn.titleLabel.text isEqualToString:@"请选择客户级别"]) {
//                            //在创建按钮下  实现本地保存
//                            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
//                                LocalCustomer * customer = [LocalCustomer MR_createEntityInContext:localContext];
//                                customer.id = self.idTextField.text;
//                                customer.address = self.adressTextField.text;
//                                customer.name = self.abbreviationTextField.text;
//                                customer.fullname = self.fullNameField.text;
//                                customer.website  = self.webTextField.text;
//                                customer.phone = self.phoneTextfield.text;
//                                customer.intro = self.introduceTextfield.text;
//                                customer.status = [NSNumber numberWithInteger:self.state];
//                                customer.level = [NSNumber numberWithInteger:self.lever];
//                                //需要存储创建时间
//                                customer.startTime = [self loadNowDateString];
//                                
//                            } completion:^(BOOL contextDidSave, NSError *error) {
//                                
//                            }];
//                                                        //保存
//                            //SMLog(@"hahah%@",customer.phone);
//                            //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//                      
                            Customer *cst = [[Customer alloc] init];
                            cst.name = self.abbreviationTextField.text;
                            cst.fullname = self.fullNameField.text;
                            cst.address = self.adressTextField.text;
                            cst.website = self.webTextField.text;
                            cst.cno = self.idTextField.text;
                            cst.phone = self.phoneTextfield.text;
                            cst.grade = self.lever;
                            cst.status = self.state;
                            SMLog(@"cst.level  %zd   self.state  %zd",cst.grade,self.state);
                            
                            [[SKAPI shared] createCustomer:cst block:^(id result, NSError *error) {
                                if (!error) {
                                    SMLog(@"result    %@",result);
                                    if ([self.delegate respondsToSelector:@selector(refreshData)]) {
                                        [self.delegate refreshData];
                                    }
                                }else{
                                    SMLog(@"error   %@",error);
                                }
                            }];
                            
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }else
                        {
                            [self showAlertViewWithMessage:@"请选择客户级别"];
                            [self hideAlertView];
                        }
                    }else
                    {
                        [self showAlertViewWithMessage:@"请选择客户状态"];
                        [self hideAlertView];
                    }
                }else
                {
                    [self showAlertViewWithMessage:@"请填写客户电话"];
                    [self hideAlertView];
                }
            }else
            {
                [self showAlertViewWithMessage:@"请填写客户编号"];
                [self hideAlertView];
            }
        }else
        {
            [self showAlertViewWithMessage:@"请填写客户全称"];
            [self hideAlertView];
        }
    }else
    {
        [self showAlertViewWithMessage:@"请填写客户昵称"];
        [self hideAlertView];
    }

}

#warning BUG  TextField 弹不出来
- (IBAction)addMorePhoneNumClick:(UIButton *)sender {
    SMLog(@"点击了 添加更多电话 按钮");
    SMCreatNewCustomerView *newNumView = [SMCreatNewCustomerView newCustomerView];
    [self.phoneNumView addSubview:newNumView];
    self.marginRow = 40;
    newNumView.frame = CGRectMake(0, _marginRow, KScreenWidth, _marginRow);
    newNumView.inputField.delegate = self;
    [self.addMoreNumView removeFromSuperview];
    
}

- (IBAction)chooseCustomerStateClick:(UIButton *)sender {
    SMLog(@"点击了 选择客户状态 按钮");
    SMCustomerStateTableViewController *customerStateVc = [[SMCustomerStateTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //反向传值
    customerStateVc.blcok = ^(NSInteger indexstate){
        self.state = indexstate;
        [self.chooseCustomerStateBtn setTitle:self.stateArray[indexstate] forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:customerStateVc animated:YES];
}

- (IBAction)chooseCustomerLevelClick:(UIButton *)sender {
    SMLog(@"点击了 选择客户级别 按钮");
    SMCustomerLevelTableViewController *customerLevelVc = [[SMCustomerLevelTableViewController alloc] init];
    customerLevelVc.levelblock = ^(NSInteger level){
        self.lever = level;
        [self.chooseCustomerLevelBtn setTitle:self.levelArray[level] forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:customerLevelVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
            [self.view endEditing:YES];
        }
//    self.view.frame =CGRectMake(0, 2 * KBEditPen, KScreenWidth, KScreenHeight);
    return YES;
}

-(NSArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    }
    return _stateArray;
}
-(NSArray *)levelArray
{
    if (!_levelArray) {
        _levelArray = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
    }
    return _levelArray;
}
-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)hideAlertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    });
    
}

//获取现在时间的字符串
-(NSString *)loadNowDateString
{
    NSDate * date = [NSDate date];
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = @"yy年MM月dd日 HH:mm";
    
    return [fmr stringFromDate:date];
}
@end
