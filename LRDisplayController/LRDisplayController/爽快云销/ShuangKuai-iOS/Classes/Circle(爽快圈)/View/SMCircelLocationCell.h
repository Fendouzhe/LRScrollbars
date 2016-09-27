//
//  SMCircelLocationCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCircelLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gouBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
