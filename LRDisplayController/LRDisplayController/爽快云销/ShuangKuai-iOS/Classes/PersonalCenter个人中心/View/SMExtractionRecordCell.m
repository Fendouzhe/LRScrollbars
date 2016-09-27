//
//  SMExtractionRecordCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMExtractionRecordCell.h"


@interface SMExtractionRecordCell ()

@end

@implementation SMExtractionRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"extractionRecordCell";
    SMExtractionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMExtractionRecordCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    self.extractionNUM.textColor = KRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCommissionLog:(CommissionLog *)commissionLog
{
    self.bankLabel.text = commissionLog.bankName;
    self.cardNumLabel.text = commissionLog.bankName;
    self.extractionNUM.text = [NSString stringWithFormat:@"%.0lf",commissionLog.commission];
    self.timeLabel.text = commissionLog.approveAt;
    
}
@end
