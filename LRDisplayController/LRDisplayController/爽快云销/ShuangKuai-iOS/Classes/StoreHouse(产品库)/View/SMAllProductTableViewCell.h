//
//  SMAllProductTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAllProductTableViewCell : UITableViewCell

/**
 *  佣金
 */
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPrice;

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UIImageView *productIconView;


@property (nonatomic ,strong)Product *product;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
