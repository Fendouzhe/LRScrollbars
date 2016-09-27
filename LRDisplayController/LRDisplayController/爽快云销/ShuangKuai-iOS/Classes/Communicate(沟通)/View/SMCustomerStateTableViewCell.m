//
//  SMCustomerStateTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerStateTableViewCell.h"

@implementation SMCustomerStateTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"customerStateTableViewCell";
    SMCustomerStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCustomerStateTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    self.nikeImage.hidden = YES;
}



@end
