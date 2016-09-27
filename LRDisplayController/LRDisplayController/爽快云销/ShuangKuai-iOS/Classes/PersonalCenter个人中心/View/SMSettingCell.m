//
//  SMSettingCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSettingCell.h"

@interface SMSettingCell ()

@end

@implementation SMSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"settingCell";
    SMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMSettingCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.cacheLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
