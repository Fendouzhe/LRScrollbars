//
//  SMConfirmPayHeaderCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConfirmPayHeaderCell.h"

@interface SMConfirmPayHeaderCell ()
/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation SMConfirmPayHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"confirmPayHeaderCell";
    SMConfirmPayHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMConfirmPayHeaderCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModle:(addressModle *)modle{
    self.consigneeLabel.text = modle.name;
    self.phoneLabel.text = modle.phone;
    self.addressLabel.text = modle.address;
}
@end
