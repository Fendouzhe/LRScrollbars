//
//  SMProductCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMProductView.h"
@interface SMProductCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong)SMProductView *productView;

@end
