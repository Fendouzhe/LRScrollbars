//
//  SMBasicInfoCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMBasicInfoCell.h"

@implementation SMBasicInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"basicInfoCell";
    SMBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMBasicInfoCell" owner:nil options:nil] lastObject];
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
