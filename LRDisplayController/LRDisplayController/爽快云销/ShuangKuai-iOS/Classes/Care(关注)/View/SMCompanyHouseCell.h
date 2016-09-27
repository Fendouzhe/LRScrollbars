//
//  SMCompanyHouseCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMCompanyHouseView;
@interface SMCompanyHouseCell : UITableViewCell

@property (nonatomic ,strong)News *news;

@property (nonatomic ,strong)SMCompanyHouseView *companyHouseView;

+ (instancetype)cellWithTableVIew:(UITableView *)tableView;

@end
