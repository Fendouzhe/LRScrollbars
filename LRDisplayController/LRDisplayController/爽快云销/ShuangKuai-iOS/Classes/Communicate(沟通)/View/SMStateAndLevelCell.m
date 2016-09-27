//
//  SMStateAndLevelCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMStateAndLevelCell.h"

@interface SMStateAndLevelCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;


@end

@implementation SMStateAndLevelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"stateAndLevelCell";
    SMStateAndLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMStateAndLevelCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setStateOrLevel:(NSString *)stateOrLevel{
    _stateOrLevel = stateOrLevel;
    self.leftLabel.text = stateOrLevel;
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
