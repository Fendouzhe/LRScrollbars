//
//  SMCustomerLevelTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomerLevelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLevel;


@property (weak, nonatomic) IBOutlet UIImageView *nikeImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
