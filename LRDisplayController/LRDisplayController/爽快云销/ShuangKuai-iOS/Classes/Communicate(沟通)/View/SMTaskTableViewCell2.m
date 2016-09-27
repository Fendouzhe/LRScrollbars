//
//  SMTaskTableViewCell2.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskTableViewCell2.h"

@interface SMTaskTableViewCell2 ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLable;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation SMTaskTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 22;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSchedule:(Schedule *)schedule{
    _schedule = schedule;
    
    self.titleLabel.text = _schedule.title;
    self.contentLabel.text = _schedule.remark;
    self.timeLabel.text = [self StringWithdate:_schedule.schTime];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_schedule.uPortrait] placeholderImage:[UIImage imageNamed:@"01"] options:SDWebImageRefreshCached completed:nil];
    
    self.statusLable.text = _schedule.status?@"已完成":@"未完成";
    
    if (_schedule.status) {
        self.statusLable.textColor = KRedColorLight;
    }else{
        self.statusLable.textColor = [UIColor grayColor];
    }
}

-(NSString *)StringWithdate:(NSInteger )time
{
    
    NSDateFormatter * frm = [[NSDateFormatter alloc]init];
    frm.dateFormat = [NSString stringWithFormat:@"yy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [frm stringFromDate:date];
}
@end
