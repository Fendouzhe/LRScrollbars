//
//  SMScheduleDetailTableViewCell3.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScheduleDetailTableViewCell3.h"

@interface SMScheduleDetailTableViewCell3 ()

@property (strong, nonatomic) IBOutlet UITextView *connectTextView;

@end
@implementation SMScheduleDetailTableViewCell3

- (void)awakeFromNib {
    // Initialization code
    self.connectTextView.editable = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLocalSchedule:(LocalSchedule *)localSchedule{
    _localSchedule = localSchedule;
    
    self.connectTextView.text = localSchedule.remark;
}

-(void)setSchedule:(Schedule *)schedule{
    _schedule = schedule;
    self.connectTextView.text = schedule.remark;
}
@end
