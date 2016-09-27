//
//  SMScheduleDetailTableViewCell1.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScheduleDetailTableViewCell1.h"

@interface SMScheduleDetailTableViewCell1 ()

/**
 *  标题
 */
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  完成按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation SMScheduleDetailTableViewCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLocalSchedule:(LocalSchedule *)localSchedule{
    _localSchedule = localSchedule;
    self.rightBtn.selected = [localSchedule.isProgress boolValue];
}

-(void)setSchedule:(Schedule *)schedule{
    _schedule = schedule;
    
    self.titleLabel.text = schedule.title;
    self.rightBtn.selected = schedule.status;
}
@end
