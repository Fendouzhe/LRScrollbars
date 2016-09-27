//
//  SMSettingCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
