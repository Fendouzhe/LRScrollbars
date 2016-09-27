//
//  SMTogetherBuyCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTogetherBuyCell : UITableViewCell

@property (nonatomic ,strong)GroupBuyMaster *master;/**< 团购模型 */

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
