//
//  SMPersonCenterCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPersonCenterCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
