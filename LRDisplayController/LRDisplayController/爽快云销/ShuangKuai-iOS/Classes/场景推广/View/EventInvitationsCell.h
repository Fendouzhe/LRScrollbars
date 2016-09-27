//
//  EventInvitationsCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventInvitatModel;
@interface EventInvitationsCell : UITableViewCell
@property (nonatomic,strong) PromotionMaster *cellData;/**< <#属性#> */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
