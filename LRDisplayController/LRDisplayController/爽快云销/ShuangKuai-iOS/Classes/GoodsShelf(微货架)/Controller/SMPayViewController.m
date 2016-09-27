//
//  SMPayViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPayViewController.h"
#import <AFNetworking.h>
#import <Pingpp.h>
#import "SMSuccessOrFailViewController.h"
#import "SMFailViewController.h"
#import "AppDelegate.h"

@interface SMPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,copy)NSArray * payTypeArray;

@property(nonatomic,copy)NSArray * payImageArray;

@property(nonatomic,copy)id charge;


@end

@implementation SMPayViewController

-(NSArray *)payTypeArray
{
    if (!_payTypeArray) {
        _payTypeArray = @[@"支付宝",@"微信支付"];
    }
    return _payTypeArray;
}
-(NSArray *)payImageArray
{
    if (!_payImageArray) {
        _payImageArray = @[@"zhifubaozhifu",@"weixinzhifu"];
    }
    return _payImageArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付方式";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    //去掉横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.payImageArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.payTypeArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMLog(@"didSelectRowAtIndexPath   %zd",indexPath.row);
    NSString * type = @"";
    if (indexPath.row==0) {
        type = @"alipay";
    }else
    {
        type = @"wx";
    }
    
    SMLog(@"%@",self.orderStr);
    //点击之后请求支付
    
    [[SKAPI shared] pingppCharge:self.orderStr andChannel:type block:^(id result, NSError *error) {

        if (!error) {
            self.charge = result;
            
            SMLog(@"pingppCharge   result =     %@  [result class]  %@",result,[result class]);
            
            [Pingpp createPayment:self.charge
                   viewController:self
                     appURLScheme:@"unizonepay"
                   withCompletion:^(NSString *result, PingppError *error) {
                       SMLog(@"%@",result);
                       if ([result isEqualToString:@"success"]) {
                           // 支付成功
                           SMSuccessOrFailViewController * success = [SMSuccessOrFailViewController new];
                           success.orderString = self.orderStr;
                           if (indexPath.row == 0) {
                               success.payWay = @"支付宝";
                           }else if (indexPath.row == 1){
                               success.payWay = @"微信";
                           }
                           [self.navigationController pushViewController:success animated:YES];
                       } else {
                           // 支付失败或取消
                           SMLog(@"Error: code=%zd msg=%@", error.code, [error getMsg]);
                           if ([[error getMsg] isEqualToString:@"用户取消操作"]) {
                               //是否添加提醒...
                           }
                           SMFailViewController * fail = [SMFailViewController new];
                           fail.orderstring = self.orderStr;
                           [self.navigationController pushViewController:fail animated:NO];
                           
                       }
                   }];
        }else{
            SMLog(@"pingppCharge   error  %@",error);
            SMShowErrorNet;
        }
        
    }];
}


-(void)loadchanger
{
    
}

@end
