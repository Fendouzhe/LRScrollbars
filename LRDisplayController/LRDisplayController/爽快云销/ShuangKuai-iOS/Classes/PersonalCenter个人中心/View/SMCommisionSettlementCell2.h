//
//  SMCommisionSettlementCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commission.h"

@interface SMCommisionSettlementCell2 : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

@property(nonatomic,strong)Commission * commission;

@property (nonatomic ,strong)SalesOrder *order;

@property(nonatomic,strong)RecentSalesOrder * recentSalesOrder;
@end
