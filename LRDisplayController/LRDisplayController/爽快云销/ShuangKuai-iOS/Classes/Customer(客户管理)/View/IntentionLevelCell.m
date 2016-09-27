//
//  IntentionLevelCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "IntentionLevelCell.h"
#import "IntentionLevelModel.h"

@implementation IntentionLevelCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"IntentionLevelCell";
    IntentionLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IntentionLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)setCellData:(IntentionLevelModel *)cellData{
    _cellData = cellData;
    self.textLabel.text = cellData.title;
}

@end
