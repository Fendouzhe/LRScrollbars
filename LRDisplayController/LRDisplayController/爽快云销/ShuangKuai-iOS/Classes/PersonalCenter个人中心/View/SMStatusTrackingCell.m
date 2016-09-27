//
//  SMStatusTrackingCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMStatusTrackingCell.h"

@implementation SMStatusTrackingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"statusTrackingCell";
    SMStatusTrackingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMStatusTrackingCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.timeLabel.textColor = KRedColor;
    self.addressLabel.textColor = KRedColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SMTrackInfo *)model{
    _model = model;
    self.timeLabel.text = model.time;
    self.addressLabel.text = model.context;
    
    CGFloat y = CGRectGetMaxY(self.timeLabel.frame);
    CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFont} context:nil].size;
    self.cellHeight = y+30+size.height+10;
}

//-(void)refreshUI:(NSDictionary *)dic{
//    SMLog(@"dic   refreshUI   %@",dic);
////    self.timeLabel.text = dic[@"time"];
////    self.addressLabel.text = dic[@"context"];
////    
////    CGFloat y = CGRectGetMaxY(self.timeLabel.frame);
////    
////    CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFont} context:nil].size;
////    self.cellHeight = y+30+size.height+10;
//}
@end
