//
//  AcceptViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AcceptViewModel;
@interface AcceptViewCell : UITableViewCell
@property (nonatomic,strong) AcceptViewModel *cellData;/**<  */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
