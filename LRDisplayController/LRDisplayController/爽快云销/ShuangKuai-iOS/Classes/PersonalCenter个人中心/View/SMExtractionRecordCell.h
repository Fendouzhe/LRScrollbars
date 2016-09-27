//
//  SMExtractionRecordCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommissionLog.h"

@interface SMExtractionRecordCell : UITableViewCell
/**
 *  银行
 */
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
/**
 *  银行卡号
 */
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
/**
 *  提取钱的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *extractionNUM;
/**
 *  时间Label
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property(nonatomic,strong)CommissionLog * commissionLog;

@end
