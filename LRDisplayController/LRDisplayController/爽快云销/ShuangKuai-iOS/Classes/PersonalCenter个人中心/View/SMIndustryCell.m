//
//  SMIndustryCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMIndustryCell.h"
#import "SMIndustry.h"

@implementation SMIndustryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"industryCell";
    SMIndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMIndustryCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setIndustry:(SMIndustry *)industry{
    _industry = industry;
    self.industryLabel.text = industry.title;
    if (industry.isSelected) {
        self.gouImageView.image = [UIImage imageNamed:@"gou"];
    }else{
        self.gouImageView.image = nil;
    }
}

@end
