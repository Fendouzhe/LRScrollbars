//
//  SMMakeDiscountDetailViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMakeDiscountDetailViewController.h"
#import "SMScanerBtn.h"
#import "SMScannerViewController.h"
#import "SMMakeDiscountDetailTableViewCell.h"
#import "SMMakeDiscountRuleTableViewCell.h"
#import "AppDelegate.h"

@interface SMMakeDiscountDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *certainBtn;

@property(nonatomic,strong)UIAlertView * alertView;



@end

@implementation SMMakeDiscountDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.codeNum) {
        [[SKAPI shared] queryCoupon:self.codeNum block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result   %@",result);
            }else{
                SMLog(@"error   %@",error);
            }
        }];
    }
    
    [self setupNav];
    
    self.certainBtn.layer.cornerRadius = 10;
    self.certainBtn.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SMMakeDiscountDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CodeCell"];
    
    [self.tableView registerClass:[SMMakeDiscountRuleTableViewCell class] forCellReuseIdentifier:@"ruleCell"];
    
    
}

-(void)setupNav
{
    self.title = @"优惠券兑换";
    
//    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
//    scanerBtn.width = 22;
//    scanerBtn.height = 22;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}
//- (void)scanerBtnDidClick{
//    //[self.searchBar resignFirstResponder];
//    SMLog(@"点击了 扫描二维码 的按钮");
//    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
//    [self.navigationController pushViewController:scannerVc animated:YES];
//}

#pragma mark -tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //优惠劵code
        SMMakeDiscountDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CodeCell"];
        cell.titleLable.text = @"优惠券优惠码:";
        cell.codeLabel.text = self.coupon.code;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1)
    {
        //rule detail
        SMMakeDiscountRuleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ruleCell"];
        //[cell setupLabelWith:@"还有谁，就问你，还有谁，还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁还有谁，就问你，还有谁"];
        [cell setupLabelWith:self.coupon.descr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        //有效期
        SMMakeDiscountDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CodeCell"];
        cell.titleLable.text = @"优惠券有效期:";
        cell.codeLabel.text = @"2016年1月10日 至 2016年3月30日";
        cell.codeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[self stringWithDate:self.coupon.startTime],[self stringWithDate:self.coupon.endTime]];
        cell.codeLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==2) {
        return 100;
    }else
    {
        NSString * str = self.coupon.descr;
        return 113+[self heightLableString:str];
    }
}

-(CGFloat)heightLableString:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth-50,KScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return size.height;
}
- (IBAction)retainAction:(UIButton *)sender {
    SMLog(@"点击了 确认使用 按钮");
    
    [self retainquerycode];
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

#pragma mark - 时间转换
-(NSString *)stringWithDate:(NSInteger)time
{
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    return [fmr stringFromDate:date];
}

-(void)retainquerycode
{
    [[SKAPI shared]useCoupon:self.coupon.code block:^(id result, NSError *error) {
        if (!error) {
            if ([result[@"message"] isEqualToString:@"success"]) {
                [self showAlertViewWithMessage:@"使用成功"];
                [self hideAlertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else
            {
                [self showAlertViewWithMessage:@"使用失败"];
                [self hideAlertView];
            }
        }else
        {
            SMLog(@"%@",error);
            if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"优惠码已被兑换"]) {
                [self showAlertViewWithMessage:@"该优惠券已被兑换"];
                [self hideAlertView];
            }else{
                [self showAlertViewWithMessage:@"似乎已断开网络连接"];
                
                [self hideAlertView];
            }
            
            
            
            
        }
    }];
}



@end
