//
//  SMCustomerStateTableViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerStateTableViewController.h"
#import "SMCustomerStateTableViewCell.h"
#import "AppDelegate.h"

@interface SMCustomerStateTableViewController ()

@property(nonatomic,copy)NSArray * stateArray;

@end

@implementation SMCustomerStateTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户状态";
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return 10;
    return self.stateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCustomerStateTableViewCell *cell = [SMCustomerStateTableViewCell cellWithTableView:tableView];
    
    cell.leftLabel.text = self.stateArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = 10;
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        SMCustomerStateTableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        cell.nikeImage.hidden = YES;
    }
    
    SMCustomerStateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.nikeImage.hidden = NO;
    SMLog(@"客户做出了选择  执行相应代码");
    
    [self setstateWith:indexPath.row];
    
}

-(NSArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    }
    return _stateArray;
}

-(void)setstateWith:(NSInteger)state
{
    self.blcok(state);
}
@end
