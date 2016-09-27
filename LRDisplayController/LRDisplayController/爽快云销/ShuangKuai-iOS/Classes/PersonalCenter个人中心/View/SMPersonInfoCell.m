//
//  SMPersonInfoCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoCell.h"

@implementation SMPersonInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"personInfoCell";
    SMPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMPersonInfoCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.iconView.image = image;
    }
    
    self.iconView.layer.cornerRadius = 25;
    self.iconView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
