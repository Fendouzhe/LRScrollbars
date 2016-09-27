//
//  SMCommisionSettlementCell1.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommisionSettlementCell1.h"

@interface SMCommisionSettlementCell1 ()
@property (weak, nonatomic) IBOutlet UILabel *grayLine;

@end

@implementation SMCommisionSettlementCell1

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"commisionSettlementCell1";
    SMCommisionSettlementCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCommisionSettlementCell1" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (void)awakeFromNib {
    self.todayIncomeLabel.textColor = KRedColor;
    self.yestodayIncomLabel.textColor = KRedColor;
    self.monthIncomeLabel.textColor = KRedColor;
    
    self.nowMonthLabel.font = KDefaultFont;
    self.lastMonthLabel.font = KDefaultFont;
    
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary *)dic
{
    SMLog(@"Cell = %@",dic);
    self.todayIncomeLabel.text = [NSString stringWithFormat:@"%@",dic[@"today_commission"]];
    self.monthIncomeLabel.text = [NSString stringWithFormat:@"%@",dic[@"month_commission"]];
    self.yestodayIncomLabel.text = [NSString stringWithFormat:@"%@",dic[@"yesterday_commission"]];
}

@end
