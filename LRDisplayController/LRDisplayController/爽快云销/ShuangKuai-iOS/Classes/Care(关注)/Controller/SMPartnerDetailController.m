//
//  SMPartnerDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPartnerDetailController.h"
#import "SMCommisionSettlementCell2.h"
#import <UIButton+WebCache.h>
#import "SMPersonInfoViewController.h"
@interface SMPartnerDetailController ()<UITableViewDelegate,UITableViewDataSource>
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//今日业绩
@property (weak, nonatomic) IBOutlet UILabel *todayAchievement;
//今天的佣金
@property (weak, nonatomic) IBOutlet UILabel *todayCommission;
//本周业绩
@property (weak, nonatomic) IBOutlet UILabel *weekAchievement;
//本周佣金
@property (weak, nonatomic) IBOutlet UILabel *weekCommission;
//本月业绩
@property (weak, nonatomic) IBOutlet UILabel *monthyAchievement;
//本月佣金
@property (weak, nonatomic) IBOutlet UILabel *monthCommission;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//最近订单 那个灰色view
@property (weak, nonatomic) IBOutlet UIView *sectionHeaderGrayView;
//最头顶的红色view
@property (weak, nonatomic) IBOutlet UIView *topRedView;

@property (nonatomic ,strong)UIButton *rightItem;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRedViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grayViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBtnW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBtnH;

@property (nonatomic,copy)NSMutableDictionary * dataDic;

@property (nonatomic,copy)NSMutableArray * dataArray;
@end

@implementation SMPartnerDetailController

-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self match];
    
    [self requestData];
}

- (void)setupNav{
    self.title = @"合伙人详情";
    
    
    UIButton *rightBtn = [[UIButton alloc] init];
    self.rightItem = rightBtn;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *rightStr = [[NSAttributedString alloc] initWithString:@"订单记录" attributes:dict];
    self.rightItem.width = 70;
    self.rightItem.height = 24;
    [self.rightItem setAttributedTitle:rightStr forState:UIControlStateNormal];
    //UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    //self.navigationItem.rightBarButtonItem = rightItem;
    [self.rightItem addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    self.rightItem.backgroundColor = [UIColor greenColor];
    
    self.topRedView.backgroundColor = SMColor(238, 38, 68);
    self.sectionHeaderGrayView.backgroundColor = KControllerBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)match{
    if (isIPhone5) {
        self.topRedViewHeight.constant = 102;
        self.midViewHeight.constant = 75;
        self.grayViewHeight.constant = 35;
        self.iconBtnW.constant = 40;
        self.iconBtnH.constant = self.iconBtnW.constant;
    }else if (isIPhone6){
        self.topRedViewHeight.constant = 102 *KMatch6Height;
        self.midViewHeight.constant = 75 *KMatch6Height;
        self.grayViewHeight.constant = 35 *KMatch6Height;
        self.iconBtnW.constant = 40 *KMatch6Height;
        self.iconBtnH.constant = self.iconBtnW.constant;
    }else if (isIPhone6p){
        self.topRedViewHeight.constant = 102 *KMatch6pHeight;
        self.midViewHeight.constant = 75 *KMatch6pHeight;
        self.grayViewHeight.constant = 35 *KMatch6pHeight;
        self.iconBtnW.constant = 40 *KMatch6pHeight;
        self.iconBtnH.constant = self.iconBtnW.constant;
    }
    
    self.iconBtn.layer.cornerRadius = self.iconBtnH.constant / 2.0;
    self.iconBtn.clipsToBounds = YES;
}

- (void)rightItemClick{
    SMLog(@"点击了 订单记录");
    
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCommisionSettlementCell2 *cell = [SMCommisionSettlementCell2 cellWithTableView:tableView];
    cell.recentSalesOrder = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 60;
    }else if (isIPhone6){
        height = 60 *KMatch6Height;
    }else if (isIPhone6p){
        height = 60 *KMatch6pHeight;
    }
    return height;
}

#pragma mark -- 点击事件
- (IBAction)iconBtnClick {
    SMLog(@"点击了 头像");
    SMPersonInfoViewController * person = [SMPersonInfoViewController new];
    person.user = self.user;
    [self.navigationController pushViewController:person animated:YES];
}

-(void)setUser:(User *)user{
    _user = user;
    
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:user.portrait] forState:UIControlStateNormal   placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    
    self.nameLabel.text = user.name;
    
}
-(void)requestData{
    SMLog(@"%@",self.user.userid);
    [[SKAPI shared] queryTeammateInfoByUserId:self.user.userid block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            self.user = [User mj_objectWithKeyValues:result[@"user"]];
            [self.dataDic setObject:result[@"monthIncome"] forKey:@"monthIncome"];
            [self.dataDic setObject:result[@"weekIncome"] forKey:@"weekIncome"];
            [self.dataDic setObject:result[@"dayIncome"] forKey:@"dayIncome"];
            for (NSDictionary * dic in result[@"salesOrderList"]) {
                RecentSalesOrder * salesOrder = [RecentSalesOrder mj_objectWithKeyValues:dic];
                [self.dataArray addObject:salesOrder];
            }
            [self refreshUI];
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
    
}
-(void)refreshUI{
    self.todayAchievement.text = [NSString stringWithFormat:@"￥%.2lf",[self.dataDic[@"dayIncome"][@"sumPrice"] doubleValue]];
    self.todayCommission.text =[NSString stringWithFormat:@"佣金:%.2lf",[self.dataDic[@"dayIncome"][@"sumCommission"] doubleValue]];
    self.weekAchievement.text = [NSString stringWithFormat:@"￥%.2lf",[self.dataDic[@"weekIncome"][@"sumPrice"] doubleValue]];
    self.weekCommission.text =[NSString stringWithFormat:@"佣金:%.2lf",[self.dataDic[@"weekIncome"][@"sumCommission"] doubleValue]];
    self.monthyAchievement.text = [NSString stringWithFormat:@"￥%.2lf",[self.dataDic[@"monthIncome"][@"sumPrice"] doubleValue]];
    self.monthCommission.text =[NSString stringWithFormat:@"佣金:%.2lf",[self.dataDic[@"monthIncome"][@"sumCommission"] doubleValue]];
}
@end
