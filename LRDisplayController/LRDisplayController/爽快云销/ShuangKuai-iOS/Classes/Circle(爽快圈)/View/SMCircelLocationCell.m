//
//  SMCircelLocationCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircelLocationCell.h"

@implementation SMCircelLocationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"circelLocationCell";
    SMCircelLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCircelLocationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.gouBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
