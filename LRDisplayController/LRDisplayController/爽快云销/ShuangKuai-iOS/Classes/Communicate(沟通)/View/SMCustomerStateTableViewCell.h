//
//  SMCustomerStateTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomerStateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nikeImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
