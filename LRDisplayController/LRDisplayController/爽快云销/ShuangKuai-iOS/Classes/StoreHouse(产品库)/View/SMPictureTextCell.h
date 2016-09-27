//
//  SMPictureTextCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPictureTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
