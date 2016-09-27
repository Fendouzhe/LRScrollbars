//
//  SMPersonInfoCell3.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoCell3.h"

@implementation SMPersonInfoCell3

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"personInfoCell3";
    SMPersonInfoCell3 *Cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (Cell == nil) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:@"SMPersonInfoCell3" owner:nil options:nil] lastObject];
    }
    return Cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
