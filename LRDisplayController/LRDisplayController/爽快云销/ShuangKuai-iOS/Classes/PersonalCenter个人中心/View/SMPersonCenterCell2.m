//
//  SMPersonCenterCell2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonCenterCell2.h"

@implementation SMPersonCenterCell2

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"personCenterCell2";
    SMPersonCenterCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMPersonCenterCell2" owner:nil options:nil] lastObject];
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
