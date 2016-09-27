//
//  SMTaskTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskTableViewCell.h"

@interface SMTaskTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//这里可以考虑用BOOL值
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *headingLable;

@property (strong, nonatomic) IBOutlet UILabel *connectLabel;

@end

@implementation SMTaskTableViewCell

+(instancetype)taskTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMTaskTableViewCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"taskTableViewCell";
    SMTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [SMTaskTableViewCell taskTableViewCell];

    }
    return cell;
}

//-(void)refreshUI:(LocalSchedule *)schedule
//{
//    self.timeLabel.text = [self StringWithdate:schedule.schTime];
//    self.headingLable.text = schedule.title;
//  
//    self.doneLabel.text = [schedule.isProgress integerValue] ? @"已完成" :@"未完成" ;
//    if ([schedule.isProgress integerValue]) {
//        [self.doneLabel setTextColor:[UIColor redColor]];
//    }else
//    {
//        [self.doneLabel setTextColor:[UIColor grayColor]];
//    }
//    
//    
//}

-(void)setSchedule:(Schedule *)schedule{
    _schedule = schedule;
    self.timeLabel.text =[self StringWithdate:schedule.schTime];
    self.headingLable.text = schedule.title;
    self.doneLabel.text = schedule.status ? @"已完成":@"未完成";
    self.connectLabel.text = schedule.remark;
    if (schedule.status) {
        [self.doneLabel setTextColor:KRedColorLight];
    }else
    {
        [self.doneLabel setTextColor:[UIColor grayColor]];
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
