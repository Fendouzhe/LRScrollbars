//
//  CustomerLevelCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerLevelCell.h"
#import "CustomerLevelModel.h"

@implementation CustomerLevelCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"CustomerLevelCell";
    CustomerLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CustomerLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)setCellData:(CustomerLevelModel *)cellData{
    _cellData = cellData;
    self.textLabel.text = cellData.title;
}
@end
