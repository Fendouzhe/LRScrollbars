//
//  SMArticalListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMArticalList;

@interface SMArticalListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong) SMArticalList *model;

@end
