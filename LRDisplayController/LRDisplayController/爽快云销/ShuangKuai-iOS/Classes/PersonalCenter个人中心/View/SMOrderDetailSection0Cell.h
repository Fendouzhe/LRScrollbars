//
//  SMOrderDetailSection0Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderDetailSection0Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
