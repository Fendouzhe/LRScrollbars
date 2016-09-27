//
//  SMBoundingAliayCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMBoundingAliayCell.h"

@interface SMBoundingAliayCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;



@end


@implementation SMBoundingAliayCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"boundingAliayCell";
    SMBoundingAliayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMBoundingAliayCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setName:(NSString *)name{
    _name = name;
    self.leftLabel.text = name;
}

- (void)setHolder:(NSString *)holder{
    _holder = holder;
    self.inputField.placeholder = holder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
