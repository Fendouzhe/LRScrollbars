//
//  EventInvitationsCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "EventInvitationsCell.h"
#import "EventInvitatModel.h"
#import "RoundCornerView.h"

@interface EventInvitationsCell ()
@property (nonatomic,strong) UIImageView *showImageView;/**< <#属性#> */
@property (nonatomic,strong) UILabel *mainLabel;/**< <#属性#> */
@property (nonatomic,strong) UILabel *timeLabel;/**< <#属性#> */
@property (nonatomic,strong) UILabel *personalLabel;/**< <#属性#> */
@property (nonatomic,strong) UILabel *personalLittleLabel;/**< <#属性#> */
@property (nonatomic,strong) RoundCornerView *timeImageView;/**< <#属性#> */
@end

@implementation EventInvitationsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"EventInvitationsCell";
    EventInvitationsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[EventInvitationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.personalLittleLabel.text =@"/人";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setCellData:(PromotionMaster *)cellData{
    _cellData = cellData;
    NSLog(@"cellData = %@",cellData.price);
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:cellData.posterImage]];
    self.mainLabel.text = cellData.name;
    NSString *startTimeStr = [self dataStrFromInterger:cellData.startTime];
    NSString *endTimeStr = [self dataStrFromInterger:cellData.endTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startTimeStr,endTimeStr];
    self.personalLabel.text = [NSString stringWithFormat:@"%@",cellData.price];
//    if ([cellData.price intValue]) {
//        [self.personalLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"￥%@",cellData.price]]];
//        self.personalLittleLabel.hidden = NO;
//    }else{
//        self.personalLabel.text = @"免费";
//        self.personalLittleLabel.hidden = YES;
//    }
}

-(NSString *)dataStrFromInterger:(NSInteger)data{
     NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:data];
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
     return [formatter stringFromDate:date1];
}

-(UIImageView *)showImageView{
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_showImageView];
        [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@(170*SMMatchWidth));
        }];
    }
    return _showImageView;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.font = KDefaultFont;
        [self.contentView addSubview:_mainLabel];
        [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.showImageView.mas_bottom).with.offset(7);
//            make.height.equalTo(@20);
        }];
    }
    return _mainLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = KDefaultFontSmall;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeImageView).with.offset(10);
//            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.mainLabel.mas_bottom).with.offset(14);
//            make.height.equalTo(@20);
        }];
    }
    return _timeLabel;
}

-(UILabel *)personalLabel{
    if (_personalLabel == nil) {
        _personalLabel = [[UILabel alloc] init];
        _personalLabel.font = KDefaultFontBig;
        _personalLabel.textColor = KRedColor;
//        _personalLabel.backgroundColor = [UIColor redColor];
        [self timeImageView];
        [self.contentView addSubview:_personalLabel];
        [_personalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.timeLabel.mas_right).with.offset(10);
//            make.right.equalTo(self.personalLittleLabel.mas_left).with.offset(-10);
            make.top.equalTo(self.mainLabel).with.offset(20);
//            make.height.equalTo(@20);
        }];
    }
    return _personalLabel;
}

-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    [attrString addAttribute:NSFontAttributeName value:KDefaultFontSmall range:NSMakeRange(0,1)];
    [attrString addAttribute:NSFontAttributeName value:KDefaultFontBig range:NSMakeRange(1,needText.length-1)];
    
    return attrString;
}


-(UILabel *)personalLittleLabel{
    if (_personalLittleLabel == nil) {
        _personalLittleLabel = [[UILabel alloc] init];
        _personalLittleLabel.font = KDefaultFontSmall;
        [self.contentView addSubview:_personalLittleLabel];
        [_personalLittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.personalLabel.mas_right);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.personalLabel.mas_bottom);
            make.left.equalTo(self.personalLabel.mas_right).with.offset(0);
//            make.height.equalTo(@10);
//            make.width.equalTo(@40);
        }];
    }
    return _personalLittleLabel;
}

-(RoundCornerView *)timeImageView{
    if (_timeImageView == nil) {
        _timeImageView = [[RoundCornerView alloc] init];
        _timeImageView.roundCorner = 4;
        _timeImageView.lineColor = KGrayColor;
        _timeImageView.backgroundColor = [UIColor whiteColor];
        
//        _timeImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_timeImageView];
        [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(5);
            make.right.equalTo(self.timeLabel).with.offset(5);
            make.top.equalTo(self.timeLabel).with.offset(-5);
            make.bottom.equalTo(self.timeLabel).with.offset(5);
        }];
    }
    return _timeImageView;
}

@end
