//
//  LRMainTableViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRMainTableViewController.h"

@interface LRMainTableViewController ()

@property(nonatomic,strong)NSArray *titlesArr;

@end

@implementation LRMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.titlesArr = @[@"腾讯视频",@"网易新闻",@"今日头条",@"喜马拉雅"];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titlesArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转的指定控制器
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"LRTXViewController" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"LRWYViewController" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"LRJRViewController" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"LRXMViewController" sender:nil];
            break;
    }
    
}
@end












