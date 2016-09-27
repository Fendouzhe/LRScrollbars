//
//  SMCommisionSettlementCell1.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCommisionSettlementCell1 : UITableViewCell
/**
 *  今日收入
 */
@property (weak, nonatomic) IBOutlet UILabel *todayIncomeLabel;
/**
 *  昨日收入
 */
@property (weak, nonatomic) IBOutlet UILabel *yestodayIncomLabel;
/**
 *  本月收入
 */
@property (weak, nonatomic) IBOutlet UILabel *monthIncomeLabel;

/**
 *  本月佣金
 */
@property (strong, nonatomic) IBOutlet UILabel *nowMonthLabel;
/**
 *  上月佣金
 */
@property (strong, nonatomic) IBOutlet UILabel *lastMonthLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)refreshUI:(NSDictionary *)dic;

@end
