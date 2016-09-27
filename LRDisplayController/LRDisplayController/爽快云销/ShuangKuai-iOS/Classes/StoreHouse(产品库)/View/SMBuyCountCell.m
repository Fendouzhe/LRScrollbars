//
//  SMBuyCountCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMBuyCountCell.h"

@interface SMBuyCountCell ()






@end

@implementation SMBuyCountCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"buyCountCell";
    SMBuyCountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMBuyCountCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction)plus {
    self.buyNum += 1;
    self.numLabel.text = [NSString stringWithFormat:@"%zd",self.buyNum];
}

- (IBAction)minus {
    if (self.buyNum <= 1) {
        return;
    }
    self.buyNum -= 1;
    self.numLabel.text = [NSString stringWithFormat:@"%zd",self.buyNum];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyNum = 1;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
