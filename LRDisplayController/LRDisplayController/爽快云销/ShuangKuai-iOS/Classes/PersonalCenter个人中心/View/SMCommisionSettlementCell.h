//
//  SMCommisionSettlementCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCommisionSettlementCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  本月销售额
 */
@property (strong, nonatomic) IBOutlet UILabel *totalsalesLabel;
/**
 *  本月待审核佣金
 */
@property (strong, nonatomic) IBOutlet UILabel *auditCommissionLabel;
/**
 *  本月已发放佣金
 */
@property (strong, nonatomic) IBOutlet UILabel *hasCommissionLabel;

@end
