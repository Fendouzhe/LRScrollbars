//
//  SMPersonInfoCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPersonInfoCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameInfoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowheadImageView;

@end
