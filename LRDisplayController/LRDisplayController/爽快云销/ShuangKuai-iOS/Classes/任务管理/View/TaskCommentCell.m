//
//  TaskCommentCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//


#import "TaskCommentCell.h"
#import "TaskCommentMessageViewModel.h"
#import "TaskCommentMessage.h"

@interface TaskCommentCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
@property (nonatomic,strong) UILabel *nameLabel;/**< 名字 */
@property (nonatomic,strong) UILabel *timeLabel;/**< 时间 */
@property (nonatomic,strong) UILabel *introLabel;/**< 内容详情 */
@property (nonatomic,strong) UIView *lineView;/**< <#属性#> */
@end

@implementation TaskCommentCell

-(void)setCellData:(TaskCommentMessageViewModel *)cellData{
    _cellData = cellData;
    [self setCellValue];
    [self setCellFrame];
}

-(void)setCellValue{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.cellData.cellData.uPortrait] placeholderImage:[UIImage imageNamed:@"220"]];
    //NSLog(@"self.cellData.cellData.uPortrait = %@",self.cellData.cellData.uPortrait);
    self.nameLabel.text = self.cellData.cellData.uName;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:self.cellData.cellData.createAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:date1];
    self.introLabel.text = self.cellData.cellData.content;
}

-(void)setCellFrame{
    self.iconImageView.frame = self.cellData.iconImageViewFrame;
    self.nameLabel.frame = self.cellData.nameLabelFrame;
    self.timeLabel.frame = self.cellData.timeLabelFrame;
    self.introLabel.frame = self.cellData.introLabelFrame;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = KTaskInfoIconWidth * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = KDefaultFontMiddle;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = KDefaultFont12;
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)introLabel{
    if (_introLabel == nil) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.numberOfLines = 0;
        _introLabel.font = KDefaultFont;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KGrayColor;
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-2);
            make.height.equalTo(@(0.5));
        }];
    }
    return _lineView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"TaskCommentCell";
    TaskCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TaskCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
