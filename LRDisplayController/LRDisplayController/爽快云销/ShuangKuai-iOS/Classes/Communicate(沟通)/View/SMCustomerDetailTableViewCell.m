//
//  SMCustomerDetailTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerDetailTableViewCell.h"

@implementation SMCustomerDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"customerDetailTableViewCell.h";
    SMCustomerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCustomerDetailTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (IBAction)moreBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(moreBtnDidClick:)]) {
        [self.delegate moreBtnDidClick:sender];
    }
}




@end
