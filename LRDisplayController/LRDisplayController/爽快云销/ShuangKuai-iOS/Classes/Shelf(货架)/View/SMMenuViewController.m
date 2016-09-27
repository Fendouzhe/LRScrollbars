//
//  SMMenuViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/7.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMenuViewController.h"

@interface SMMenuViewController ()

@end

@implementation SMMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"添加商品";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"删除模板";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40
    ;
}

@end
