//
//  SMCustomerLevelTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerLevelTableViewCell.h"

@implementation SMCustomerLevelTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"customerLevelTableViewCell";
    SMCustomerLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCustomerLevelTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.nikeImage.hidden = YES;
}

@end
