//
//  SMMyInComeViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyInComeViewController.h"
#import "SMMyInComeTableViewCell.h"
#import "SMMyBonusViewController.h"
#import "SMCommissionSettlementViewController.h"
#import "SMBankViewController.h"
#import "SMBoundingAlipayVc.h"
#define cellHeight 50
@interface SMMyInComeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView * tableView;


@property(nonatomic,copy)NSArray * titleArray;
@property(nonatomic,copy)NSArray * imageArray;

@end

@implementation SMMyInComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

-(void)setupUI{
    self.title = @"我的收入";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.titleArray = @[@"佣金结算",@"我的奖金",@"我的支付宝",@"我的银行卡"];
    self.imageArray = @[@"yongjin",@"jiangjin",@"支付宝icon",@"yinhangka"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, KScreenWidth, cellHeight*self.titleArray.count + 2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = KControllerBackGroundColor;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SMMyInComeTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.tableView.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.tableView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.tableView.layer.shadowRadius = 1;//阴影半径，默认3
    
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
   
}

#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMMyInComeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    if (indexPath.row == 1 && level2) {
        return cell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    [cell refreshUI:self.imageArray[indexPath.row] andTitle:self.titleArray[indexPath.row]];

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    
    if (!level2) {
        //1级
        return cellHeight;
    }else{
        //2级
        if (indexPath.row == 1) {
            return 0;
        }
        return cellHeight;
    }
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //佣金结算
        SMCommissionSettlementViewController *commisionVc = [[SMCommissionSettlementViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:commisionVc animated:YES];
    }else if (indexPath.row == 1){
        //我的奖金
        SMMyBonusViewController * bonus = [SMMyBonusViewController new];
        [self.navigationController pushViewController:bonus animated:YES];
    }else if (indexPath.row == 2){  //支付宝
        SMBoundingAlipayVc *vc = [SMBoundingAlipayVc new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{ //我的银行卡
        
        SMBankViewController *bankVc = [[SMBankViewController alloc] init];
        [self.navigationController pushViewController:bankVc animated:YES];
    }
}

@end
