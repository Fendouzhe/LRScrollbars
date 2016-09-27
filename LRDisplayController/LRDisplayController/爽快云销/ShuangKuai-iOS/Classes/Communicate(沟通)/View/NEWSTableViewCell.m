//
//  NEWSTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "NEWSTableViewCell.h"

@interface NEWSTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *unreadBtn;

@end
@implementation NEWSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.unreadBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)communicateCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"NEWSTableViewCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"NewsCell";
    NEWSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [NEWSTableViewCell communicateCell];
    }
    return cell;
}
@end
