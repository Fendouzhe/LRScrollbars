//
//  SMCommisionSettlementCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommisionSettlementCell.h"

@interface SMCommisionSettlementCell ()

@property (weak, nonatomic) IBOutlet UIView *grayView;

@end

@implementation SMCommisionSettlementCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"commisionSettlementCell";
    SMCommisionSettlementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCommisionSettlementCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    self.totalsalesLabel.textColor = KRedColorLight;
    self.auditCommissionLabel.textColor = KRedColorLight;
    self.hasCommissionLabel.textColor = KRedColorLight;
    
    self.totalsalesLabel.font = KDefaultFont;
    self.auditCommissionLabel.font = KDefaultFont;
    self.hasCommissionLabel.font = KDefaultFont;
    
    self.grayView.backgroundColor = KGrayColorSeparatorLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
