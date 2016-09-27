//
//  SMGroupChatMemberListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatMemberListCell.h"
#import "ChatroomMemberListData.h"
//#import "SMGroupChatListData.h"
//#import "SMGroupChatDetailData.h"


@interface SMGroupChatMemberListCell ()
@property (nonatomic,weak) UIImageView *iconView;/**< 头像 */
@property (nonatomic,weak) UILabel *groupLabel;/**< 群名称 */
@end

@implementation SMGroupChatMemberListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"SMGroupChatMemberListCell";
    SMGroupChatMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

-(void)setCellData:(ChatroomMemberListData *)cellData{
    _cellData = cellData;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellData.portrait] placeholderImage:[UIImage imageNamed:@"220"]];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:KUserName];
    //SMLog(@"self.remark = %@",self.remark);
    if ([cellData.name isEqualToString:userName]) {
        self.groupLabel.text = self.remark;
    }else{
        self.groupLabel.text = cellData.name;
    }
 //   self.groupLabel.text = cellData.name;
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
