//
//  SMMyCaredCompanyCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMyCaredCompanyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconView;

@property (weak, nonatomic) IBOutlet UILabel *detailInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)Company * company;

@end
