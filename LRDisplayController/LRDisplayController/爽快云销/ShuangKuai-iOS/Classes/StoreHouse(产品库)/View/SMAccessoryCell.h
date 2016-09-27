//
//  SMAccessoryCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAccessoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
