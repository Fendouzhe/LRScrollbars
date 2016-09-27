//
//  SMEventInvitationsCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMEventInvitationsCell : UITableViewCell

@property (nonatomic,strong) PromotionMaster *cellData;/**< <#属性#> */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
