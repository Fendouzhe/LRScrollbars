//
//  SMBuyCountCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMBuyCountCell : UITableViewCell

@property (nonatomic ,assign)NSInteger buyNum;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
