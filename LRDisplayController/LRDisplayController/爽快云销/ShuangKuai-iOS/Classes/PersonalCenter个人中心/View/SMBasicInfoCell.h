//
//  SMBasicInfoCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMBasicInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
/**
 *  箭头
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
