//
//  SMDetailProductSection1Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailProductSection1Cell : UITableViewCell
/**
 *  公司图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**
 *  公司名字，提供商
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *grayLine;
@property (nonatomic ,strong)Product *product;

+ (instancetype)detailProductSection1Cell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
