//
//  SMBonusTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMBonusTableViewCell.h"

@interface SMBonusTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
@implementation SMBonusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBonus:(Bonus *)bonus{
    _bonus = bonus;
    
    self.titleLabel.text = bonus.name;
    self.timeLabel.text = [self getTimeFromTimestamp:bonus.createAt/1000.0];
    self.nameLabel.text = bonus.fromUserName;
    self.phoneLabel.text = bonus.sourceId;
    self.moneyLabel.text  = [NSString stringWithFormat:@"￥%.2lf",bonus.money];
    
}


//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}
@end
