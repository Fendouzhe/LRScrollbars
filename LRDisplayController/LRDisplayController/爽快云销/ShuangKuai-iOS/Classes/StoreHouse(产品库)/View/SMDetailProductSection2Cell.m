//
//  SMDetailProductSection2Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductSection2Cell.h"

@implementation SMDetailProductSection2Cell

+ (instancetype)detailProductSection2Cell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDetailProductSection2Cell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"detailProductSection2Cell";
    SMDetailProductSection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMDetailProductSection2Cell detailProductSection2Cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
