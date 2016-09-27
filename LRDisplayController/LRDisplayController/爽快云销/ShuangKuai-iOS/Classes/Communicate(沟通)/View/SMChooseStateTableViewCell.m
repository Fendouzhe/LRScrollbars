//
//  SMChooseStateTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMChooseStateTableViewCell.h"

@implementation SMChooseStateTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"chooseStateTableViewCell";
    SMChooseStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMChooseStateTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
