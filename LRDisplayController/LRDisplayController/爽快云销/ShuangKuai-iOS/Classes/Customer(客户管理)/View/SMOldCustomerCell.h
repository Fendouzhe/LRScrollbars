//
//  SMOldCustomerCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOldCustomerCell : UITableViewCell

@property (nonatomic ,strong)Customer *customer;/**< <#注释#> */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
