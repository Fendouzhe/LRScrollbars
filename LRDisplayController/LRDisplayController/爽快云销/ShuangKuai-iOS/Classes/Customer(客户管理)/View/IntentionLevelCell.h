//
//  IntentionLevelCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntentionLevelModel;
@interface IntentionLevelCell : UITableViewCell
@property (nonatomic,strong) IntentionLevelModel *cellData;/**< cellData */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
