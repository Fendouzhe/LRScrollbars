//
//  SMGroupChatListTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatListTableViewCell.h"
#import "SMGroupChatListData.h"
@interface SMGroupChatListTableViewCell ()
@property (nonatomic,weak) UIImageView *iconView;/**< 头像 */
@property (nonatomic,weak) UILabel *groupLabel;/**< 群名称 */
@end

@implementation SMGroupChatListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"SMGroupChatListTableViewCell";
    SMGroupChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMGroupChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 20;
        iconView.clipsToBounds = YES;
        iconView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *groupLabel = [[UILabel alloc] init];
        groupLabel.textColor = [UIColor blackColor];
        groupLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:groupLabel];
        self.groupLabel = groupLabel;
    }
    return self;
}

-(void)setCellData:(SMGroupChatListData *)cellData{
    _cellData = cellData;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellData.imageUrl]];
    self.groupLabel.text = cellData.roomName;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(5, (41 *SMMatchHeight+10 - 40)*0.5, 40, 40);
    
    CGSize labelSize = [@"a" sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 100)];
    self.groupLabel.frame = CGRectMake(60, (41 *SMMatchHeight+10 - labelSize.height)*0.5  , KScreenWidth - 100, 20 );
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
