//
//  SMPosterListCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPosterListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong)SMPosterList *model;/**< <#注释#> */

@end
