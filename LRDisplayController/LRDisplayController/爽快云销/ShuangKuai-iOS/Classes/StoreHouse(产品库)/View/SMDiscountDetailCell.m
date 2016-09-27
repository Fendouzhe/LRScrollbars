//
//  SMDiscountDetailCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscountDetailCell.h"
#import "NSString+Extension.h"

@interface SMDiscountDetailCell ()
/**
 *  优惠券详情
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
/**
 *   使用规则
 */
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
/**
 *  有效期label
 */
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodLabel;
/**
 *  使用时间
 */
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;

@end

@implementation SMDiscountDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"discountDetailCell";
    SMDiscountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMDiscountDetailCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    
    CGFloat margin = 10;
    CGFloat oneRowH = [self.useTimeLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
    
    //优惠券详情介绍占用的高度
    CGFloat discountDetailH = [self.detailLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
    
    //使用规则下面的label 占用的高度
    CGFloat ruleInfoH = [self.ruleLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
    
    self.cellHeight = margin * 7 + oneRowH * 4 + discountDetailH + ruleInfoH;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
