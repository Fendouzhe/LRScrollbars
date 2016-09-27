//
//  SMNewCustomerManagerCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewCustomerManagerCell : UITableViewCell

@property (nonatomic ,strong)Customer *cus;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
