//
//  TaskListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskListCell.h"
#import "TaskListModel.h"
#import "TaskListViewModel.h"
#import "MLLinkLabel.h"

@interface TaskListCell ()<MLLinkLabelDelegate>
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
@property (nonatomic,strong) UILabel *nameLabel;/**< 名字 */
@property (nonatomic,strong) UILabel *timeLabel;/**< 任务发布时间 */
@property (nonatomic,strong) UILabel *mainLabel;/**< 任务标题 */
@property (nonatomic,strong) UILabel *introLabel;/**< 任务详情 */
@property (nonatomic,strong) UIImageView *deadlineImageView;/**< icon */
@property (nonatomic,strong) UILabel *deadlineLabel;/**< 截止时间 */
@property (nonatomic,strong) MLLinkLabel *participantLabel;/**< 参与人 */
@property (nonatomic,strong) UILabel *publishTypeLabel;/**< 发布状态 */
@property (nonatomic,strong) UIView *lineView;/**< <#属性#> */
@property (nonatomic,strong) UILabel *childNumberLabel;/**< 子任务数 */
@end

@implementation TaskListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"TaskListCell";
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)setCellData:(TaskListViewModel *)cellData{
    _cellData = cellData;
    [self setValue];
    [self setFrame];
}

-(void)setValue{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.cellData.cellData.schedule.uPortrait] placeholderImage:[UIImage imageNamed:@"220"]];
    self.nameLabel.text = self.cellData.cellData.schedule.uName;
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:self.cellData.cellData.schedule.createAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    self.timeLabel.text = [formatter stringFromDate:date1];
    self.mainLabel.text = self.cellData.cellData.schedule.title;
    self.introLabel.text = [NSString stringWithFormat:@"任务内容:%@",self.cellData.cellData.schedule.remark];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:self.cellData.cellData.schedule.schTime];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    self.deadlineLabel.text = [formatter stringFromDate:date2];
    self.deadlineLabel.text = [NSString stringWithFormat:@"截止时间:%@",[formatter stringFromDate:date2]];
    
    if (self.participantLabel.superview) {
        [self.participantLabel removeFromSuperview];
    }else{
    }
    self.participantLabel = self.cellData.linkLabel;
    [self.contentView addSubview:self.participantLabel];
    MJWeakSelf
    [self.participantLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        SMLog(@"%@",link.linkValue);
        if ([weakSelf.delegate respondsToSelector:@selector(clickNameWithUserID:)]) {
            [weakSelf.delegate clickNameWithUserID:link.linkValue];
        }
    }];
    
    switch (self.cellData.cellData.schedule.status) {
        case 0:
        {
            self.publishTypeLabel.text = @"未发布";
            self.publishTypeLabel.textColor = [UIColor blackColor];
        }
            break;
        case 1:
        {
            self.publishTypeLabel.text = @"未完成";
            self.publishTypeLabel.textColor = KRedColorLight;
        }
            break;
        case 2:
        {
            self.publishTypeLabel.text = @"已完成";
            self.publishTypeLabel.textColor = [UIColor lightGrayColor];
        }
            break;
        default:
            break;
    }
    self.childNumberLabel.text = [NSString stringWithFormat:@"子任务数:%ld",(long)self.cellData.cellData.schedule.childSchedule];
}

-(void)setFrame{
    self.iconImageView.frame = self.cellData.iconImageFrame;
    self.nameLabel.frame = self.cellData.nameLabelFrame;
    self.timeLabel.frame = self.cellData.timeLabelFrame;
    self.mainLabel.frame = self.cellData.mainLabelFrame;
    self.introLabel.frame = self.cellData.introLabelFrame;
    self.deadlineImageView.frame = self.cellData.deadlineImageFrame;
    self.deadlineLabel.frame = self.cellData.deadlineFrame;
    self.participantLabel.frame = self.cellData.participantLabelFrame;
    self.publishTypeLabel.frame = self.cellData.publishTypeLabelFrame;
    self.lineView.frame = self.cellData.lineViewFrame;
    self.childNumberLabel.frame = self.cellData.childNumberLabelFrame;
}

//-(MLLinkLabel *)participantLabel{
//    if (_participantLabel == nil) {
//        _participantLabel = [[MLLinkLabel alloc] init];
//        [self.contentView addSubview:_participantLabel];
//    }
//    return _participantLabel;
//}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        UIFont *font = KDefaultFontBig;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _nameLabel.font = font;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = KGrayColor;
        _timeLabel.font = KDefaultFontSmall;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.font = KDefaultFontBig;
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
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

-(UIImageView *)deadlineImageView{
    if (_deadlineImageView == nil) {
        _deadlineImageView = [[UIImageView alloc] init];
        _deadlineImageView.image = [UIImage imageNamed:@"shijian"];
        [self.contentView addSubview:_deadlineImageView];
    }
    return _deadlineImageView;
}

-(UILabel *)deadlineLabel{
    if (_deadlineLabel == nil) {
        _deadlineLabel = [[UILabel alloc] init];
        _deadlineLabel.textColor = KGrayColor;
        _deadlineLabel.font = KDefaultFont;
        [self.contentView addSubview:_deadlineLabel];
    }
    return _deadlineLabel;
}

-(UILabel *)childNumberLabel{
    if (_childNumberLabel == nil) {
        _childNumberLabel = [[UILabel alloc] init];
        _childNumberLabel.textColor = KGrayColor;
        _childNumberLabel.font = KDefaultFont;
        [self.contentView addSubview:_childNumberLabel];
    }
    return _childNumberLabel;
}


-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KGrayColorSeparatorLine;
        [self addSubview:_lineView];
    }
    return _lineView;
}


-(UILabel *)publishTypeLabel{
    if (_publishTypeLabel == nil) {
        _publishTypeLabel = [[UILabel alloc] init];
        _publishTypeLabel.font = KDefaultFontBig;
        [self.contentView addSubview:_publishTypeLabel];
    }
    return _publishTypeLabel;
}

//- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
//{
//    SMLog(@"%@", link.linkValue);
//}



@end
