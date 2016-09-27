//
//  SMCommisionSettlementCell2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommisionSettlementCell2.h"

@interface SMCommisionSettlementCell2 ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *grayLine;

@end
@implementation SMCommisionSettlementCell2

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"commisionSettlementCell2";
    SMCommisionSettlementCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCommisionSettlementCell2" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.moneyLabel.textColor = KRedColorLight;
    self.moneyLabel.font = KDefaultFont;
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrder:(SalesOrder *)order{
    _order = order;
    self.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",order.createAt]];
    self.orderLable.text = [NSString stringWithFormat:@"关联账单:%@",order.sn];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",order.sumCommission];
}


-(void)setCommission:(Commission *)commission
{
    self.timeLabel.text = [Utils getTimeFromTimestamp:commission.createAt];
    self.orderLable.text = commission.sn;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",commission.commission];

}

-(void)setRecentSalesOrder:(RecentSalesOrder *)recentSalesOrder{
    _recentSalesOrder = recentSalesOrder;
    
    self.timeLabel.text = [Utils getTimeFromTimestamp:recentSalesOrder.createAt];
    self.orderLable.text = recentSalesOrder.sn;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",recentSalesOrder.sumCommission];
}
@end
