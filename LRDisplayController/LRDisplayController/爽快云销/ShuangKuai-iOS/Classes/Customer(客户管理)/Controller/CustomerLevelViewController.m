//
//  CustomerLevelViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerLevelViewController.h"
#import "CustomerLevelCell.h"
#import "CustomerLevelModel.h"

@interface CustomerLevelViewController ()
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@property (nonatomic,copy) NSString *selectText;/**< 文字 */
@end

@implementation CustomerLevelViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"客户等级";//vip,大型客户,中型客户,小型客户
    
    CustomerLevelModel *model01 = [[CustomerLevelModel alloc] init];
    model01.title = @"vip";
    
    CustomerLevelModel *model02 = [[CustomerLevelModel alloc] init];
    model02.title = @"大型客户";
    
    CustomerLevelModel *model03 = [[CustomerLevelModel alloc] init];
    model03.title = @"中型客户";
    
    CustomerLevelModel *model04 = [[CustomerLevelModel alloc] init];
    model04.title = @"小型客户";
    
    self.dataArray = @[model01,model02,model03,model04];
    [self.tableView reloadData];
    
//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = KDefaultFontBig;
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确定" attributes:dict];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    [rightBtn sizeToFit];
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.view.backgroundColor = KControllerBackGroundColor;
}

-(void)rightItemClick{
    if (!self.selectText.length) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(chooseCustomerLevel:)]){
        [self.delegate chooseCustomerLevel:self.selectText];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerLevelCell *cell = [CustomerLevelCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectText = [self.dataArray[indexPath.row] title];
}
@end
