//
//  SMAllActionTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMAllActionTableViewCell : UITableViewCell

@property (nonatomic ,strong)FavoritesDetail *favDetail;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,strong)Activity *action;


/**
 *  cell左上角的勾勾 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *gouBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
