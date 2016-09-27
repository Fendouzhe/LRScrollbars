//
//  SMBankDetailInfoController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMBankDetailInfoController.h"
#import "SMBankCardCell.h"
#import "AppDelegate.h"


@interface SMBankDetailInfoController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *releaseBoundBtn;
/**
 *  最下方解除绑定的整体view
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property(nonatomic,strong)UIAlertView * alertView;

@end

@implementation SMBankDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)setup{
    self.title = @"银行卡详情";
    
    [self.releaseBoundBtn setBackgroundColor:KRedColorLight];
    self.releaseBoundBtn.layer.cornerRadius = SMCornerRadios;
    self.releaseBoundBtn.clipsToBounds = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = KControllerBackGroundColor;
}

#pragma mark -- 点击事件
- (IBAction)releaseBoundBtnClick:(id)sender {
    SMLog(@"点击了 解除绑定按钮");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要解除绑定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMBankCardCell *cell = [SMBankCardCell cellWithTableView:tableView];
    cell.bankColor = self.bankColor;
    [cell refreshUI:self.bankcard];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //解除绑定
        [self getbankcard];
    }
}


-(void)getbankcard
{
    [[SKAPI shared] unbindCard:self.bankcard.account andType:1 block:^(id result, NSError *error) {
        if (!error) {
            if ([result[@"message"] isEqualToString:@"success"]) {
                [self showAlertViewWithMessage:@"解绑成功"];
                [self hideAlertView];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showAlertViewWithMessage:@"解绑失败"];
                [self hideAlertView];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else
        {
            [self showAlertViewWithMessage:@"网络错误 请检查网络"];
            [self hideAlertView];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}

-(void)hideAlertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    });
}
@end
