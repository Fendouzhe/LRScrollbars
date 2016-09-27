//
//  SMMyCaredCompanyCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyCaredCompanyCell.h"

@implementation SMMyCaredCompanyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"myCaredCompanyCell";
    SMMyCaredCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMyCaredCompanyCell" owner:nil options:nil] lastObject];
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

-(void)setCompany:(Company *)company
{
    _company = company;
    
    self.companyName.text = company.name;
    self.detailInfoLabel.text = company.descr;
    
    [self.iconView setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:company.logoPath]]] forState:UIControlStateNormal];
}

@end
