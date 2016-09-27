//
//  SMSeckillListCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSeckillListCell : UITableViewCell

@property (nonatomic ,strong)SMSeckill *model;/**< <#注释#> */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
