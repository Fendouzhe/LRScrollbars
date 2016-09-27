//
//  SMSearchCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
