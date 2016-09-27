//
//  SMSellLogTableViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSellLogTableViewController.h"
#import "SMSellLogTableViewCell.h"
#import "SMDetailLogViewController.h"
#import "LocalWorkLog+CoreDataProperties.h"
#import "LocalCustomer+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"

@interface SMSellLogTableViewController ()

@end

@implementation SMSellLogTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"销售日志";
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //return 3;
    return [LocalCustomer MR_findAll].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* array  = [LocalCustomer MR_findAll];
    LocalCustomer * localcustomer = array[array.count-1-section];
    NSArray * subArray = [LocalWorkLog MR_findByAttribute:@"id" withValue:localcustomer.id];
    //return 1;
    return subArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSellLogTableViewCell *cell = [SMSellLogTableViewCell cellWithTableView:tableView];
    
    NSArray* array  = [LocalCustomer MR_findAll];
   
    if (array.count>0) {
        LocalCustomer * localcustomer = array[array.count -1-indexPath.section];
        NSArray * subArray = [LocalWorkLog MR_findByAttribute:@"id" withValue:localcustomer.id];
        if (subArray.count>0) {
            //cell.localworklog = subArray[indexPath.row];
            [cell refreshUIWithLocalworklog:subArray[subArray.count-1-indexPath.row] andWithLocalCustomer:localcustomer];
        }
       
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 61;
    }else if (isIPhone6){
        height = 61 *KMatch6;
    }else if (isIPhone6p){
        height = 61 *KMatch6p;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMDetailLogViewController *detailLogVc = [[SMDetailLogViewController alloc] init];
    
    NSArray* array  = [LocalCustomer MR_findAll];
    if (array.count>0) {
        LocalCustomer * localcustomer = array[array.count -1-indexPath.section];
        NSArray * subArray = [LocalWorkLog MR_findByAttribute:@"id" withValue:localcustomer.id];
        if (subArray.count>0) {
            //cell.localworklog = subArray[indexPath.row];
            detailLogVc.localworklog = subArray[subArray.count-1-indexPath.row];
            detailLogVc.localCustomer = localcustomer;
            //在这边调用，不起作用了。。。。。。。
//            [detailLogVc refreshUIWithLocalworklog:subArray[subArray.count-1-indexPath.row] andWithLocalCustomer:localcustomer];
        }
    }
    
    [self.navigationController pushViewController:detailLogVc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* array  = [LocalCustomer MR_findAll];
    LocalCustomer * localcustomer = array[array.count -1-indexPath.section];
    NSArray * subArray = [LocalWorkLog MR_findByAttribute:@"id" withValue:localcustomer.id];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocalWorkLog * localworklog = subArray[subArray.count-1-indexPath.row];
        [localworklog MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.tableView reloadData];
    }
}
@end
