//
//  SMOrderDetailSection0Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailSection0Cell.h"

@implementation SMOrderDetailSection0Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"orderDetailSection0Cell";
    SMOrderDetailSection0Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMOrderDetailSection0Cell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.rightLabel.textColor = [UIColor darkGrayColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
