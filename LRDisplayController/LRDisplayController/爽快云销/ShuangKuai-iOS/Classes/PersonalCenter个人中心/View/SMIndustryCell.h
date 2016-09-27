//
//  SMIndustryCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMIndustry;
@interface SMIndustryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *industryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;

@property (nonatomic ,strong)SMIndustry *industry;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
