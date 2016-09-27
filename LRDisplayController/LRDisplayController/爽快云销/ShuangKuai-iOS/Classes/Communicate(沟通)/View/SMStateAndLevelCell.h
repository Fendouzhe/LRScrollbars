//
//  SMStateAndLevelCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMStateAndLevelCell : UITableViewCell

@property (nonatomic ,copy)NSString *stateOrLevel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
