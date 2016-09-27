//
//  SMChangeLevelController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChangeLevelController.h"
#import "SMStateAndLevelCell.h"

@interface SMChangeLevelController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSArray *arrLevelMenu;

@end

@implementation SMChangeLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更改客户级别";
    self.arrLevelMenu = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
    self.view.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrLevelMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMStateAndLevelCell *cell = [SMStateAndLevelCell cellWithTableView:tableView];
    cell.stateOrLevel = self.arrLevelMenu[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.cus.grade = indexPath.row;
    [[SKAPI shared] updateCustomer:self.cus block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            if ([self.delegate respondsToSelector:@selector(refreshLevelWith:)]) {
                [self.delegate refreshLevelWith:self.cus];
            }
        }else{
            SMLog(@"error  %@",error);
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
