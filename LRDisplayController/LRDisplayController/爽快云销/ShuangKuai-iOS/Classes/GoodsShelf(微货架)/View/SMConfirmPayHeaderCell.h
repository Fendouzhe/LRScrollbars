//
//  SMConfirmPayHeaderCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModle.h"

@interface SMConfirmPayHeaderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)addressModle * modle;

@end
