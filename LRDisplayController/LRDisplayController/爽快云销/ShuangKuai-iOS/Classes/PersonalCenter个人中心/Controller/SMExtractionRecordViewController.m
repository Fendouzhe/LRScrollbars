//
//  SMExtractionRecordViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMExtractionRecordViewController.h"
#import "SMExtractionRecordCell.h"
#import "CommissionLog.h"
#import "AppDelegate.h"

@interface SMExtractionRecordViewController ()

@property(nonatomic,copy)NSMutableArray * commissionLogDataArray;
@end

@implementation SMExtractionRecordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提取记录";
    //去掉cell的线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 4;
    return self.commissionLogDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMExtractionRecordCell *cell = [SMExtractionRecordCell cellWithTableView:tableView];
    
    cell.commissionLog = self.commissionLogDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


#warning 本地没缓存
-(NSMutableArray *)commissionLogDataArray
{
    if (!_commissionLogDataArray) {
        _commissionLogDataArray = [NSMutableArray array];
    }
    return _commissionLogDataArray;
}
-(void)requestExtractionRecordDatas
{
    [[SKAPI shared] queryCommissionLogByPage:0 andSize:20 block:^(NSArray *array, NSError *error) {
        //self.commissionLogDataArray = [array mutableCopy];
        for (CommissionLog * log in array) {
            [self.commissionLogDataArray addObject:log];
        }
        [self.tableView reloadData];
    }];
}

@end
