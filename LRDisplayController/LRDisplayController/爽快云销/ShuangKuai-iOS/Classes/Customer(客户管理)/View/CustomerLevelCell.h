//
//  CustomerLevelCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerLevelModel;
@interface CustomerLevelCell : UITableViewCell
@property (nonatomic,strong) CustomerLevelModel *cellData;/**< cellData */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
