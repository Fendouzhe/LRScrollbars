//
//  SMPersonInfoCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPersonInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
