//
//  SMCustomerLevelTableViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerLevelTableViewController.h"
#import "SMCustomerStateTableViewCell.h"
#import "SMCustomerLevelTableViewCell.h"
#import "AppDelegate.h"
@interface SMCustomerLevelTableViewController ()

@property(nonatomic,copy)NSArray * levelArray;

@end

@implementation SMCustomerLevelTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户分级";
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return 5;
    return self.levelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCustomerLevelTableViewCell *cell = [SMCustomerLevelTableViewCell cellWithTableView:tableView];
    cell.leftLevel.text = self.levelArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = 10;
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        SMCustomerLevelTableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        cell.nikeImage.hidden = YES;
    }
    
    SMCustomerLevelTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.nikeImage.hidden = NO;
    SMLog(@"客户做出了选择  执行相应代码");
    [self chooseLevel:indexPath.row];
}

-(NSArray *)levelArray
{
    if (!_levelArray) {
        _levelArray = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
    }
    return _levelArray;
}
-(void)chooseLevel:(NSInteger)level
{
    self.levelblock(level);
}

@end
