//
//  SMOrderDetailSection1Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailSection1Cell.h"

@implementation SMOrderDetailSection1Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"orderDetailSection1Cell";
    SMOrderDetailSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMOrderDetailSection1Cell" owner:nil options:nil] lastObject];
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


@end
