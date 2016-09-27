//
//  SMChooseNumCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/19.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMChooseNumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
