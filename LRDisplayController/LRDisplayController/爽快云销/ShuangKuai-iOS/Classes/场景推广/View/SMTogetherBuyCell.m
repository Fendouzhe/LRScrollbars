//
//  SMTogetherBuyCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTogetherBuyCell.h"

@interface SMTogetherBuyCell ()

@property (weak, nonatomic) IBOutlet UILabel *day;

@property (weak, nonatomic) IBOutlet UILabel *hour;

@property (weak, nonatomic) IBOutlet UILabel *minite;

@property (weak, nonatomic) IBOutlet UILabel *second;

@property (weak, nonatomic) IBOutlet UILabel *alreadyJoinPeople; //以参团人数

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (nonatomic ,copy)NSString *actionEndTimeStr;/**< 活动截止时间 */

@property (nonatomic ,copy)NSString *actionStartTimeStr;/**< 活动开始时间 */

@property (nonatomic ,copy)NSString *currentTime;/**< 现在时间 */

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;//剩余label


@end

@implementation SMTogetherBuyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"togetherBuyCell";
    SMTogetherBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMTogetherBuyCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconHeight.constant = 170 *SMMatchHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLastTime) name:KRefreshLastTimNotification object:nil];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
}

- (void)setMaster:(GroupBuyMaster *)master{
    _master = master;
    
    NSString *iconPath = [master.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"220"]];
    self.alreadyJoinPeople.text = [NSString stringWithFormat:@"已有%zd人参团",master.buyNum];
    self.name.text = master.name;
    SMLog(@"master.endTime %zd  master.startTime  %zd  master.name = %@",master.endTime,master.startTime,master.name);
    NSString *endTime = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",master.endTime]];
    //将结束时间转为时间戳
    NSInteger endTsamp = [self getTimeStampFromeTimeStr:endTime];
    
    self.actionEndTimeStr = endTime;
    NSString *startTime = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",master.startTime]];
    self.actionStartTimeStr = startTime;
    //将开始时间转成时间戳
    NSInteger startStamp = [self getTimeStampFromeTimeStr:startTime];
    
    //获取当前时间
    NSString *currentTome = [self getCurrentTime];
    self.currentTime = currentTome;
    //将当前时间转成时间戳
    NSInteger currentStamp = [self getTimeStampFromeTimeStr:currentTome];
    
    

    if (startStamp > currentStamp) { //活动没开始
        self.master.clickState = 1;
    }else if (startStamp <= currentStamp && endTsamp > currentStamp){//活动开始并尚未结束
        self.master.clickState = 2;
    }else if (endTsamp < currentStamp){ //活动已结束
        self.master.clickState = 3;
    }else{
        SMLog(@"我擦  时间判断 有漏网之鱼");
    }
        
}

//刷新活动还剩余多少时间
- (void)refreshLastTime{
//    self.actionEndTimeStr = @"2016-10-01 23:59:59";
    if (self.actionEndTimeStr == nil || self.actionStartTimeStr == nil) {
        return;
    }
    
    //获取当前时间
    NSString *currentTome = [self getCurrentTime];
    self.currentTime = currentTome;
    
    //SMLog(@"self.master.clickState  %zd",self.master.clickState);
    if (self.master.clickState == 1) { //活动没开始
        self.lastLabel.text = @"距离活动开始还有";
        self.lastLabel.textColor = KRedColorLight;
//        [self refreshTimeLabelsWith:self.actionStartTimeStr andToTime:self.currentTime textColor:[UIColor darkGrayColor]];
        [self refreshTimeLabelsWith:self.currentTime andToTime:self.actionStartTimeStr textColor:[UIColor darkGrayColor]];
    }else if (self.master.clickState == 2){//活动正在进行
        self.lastLabel.text = @"剩余";
        self.lastLabel.textColor = [UIColor darkGrayColor];
//        [self refreshTimeLabelsWith:self.actionEndTimeStr andToTime:self.currentTime textColor:KRedColorLight];
        [self refreshTimeLabelsWith:self.currentTime andToTime:self.actionEndTimeStr textColor:KRedColorLight];
    }else if (self.master.clickState == 3){//活动已结束
        self.lastLabel.text = @"剩余";
        self.lastLabel.textColor = [UIColor darkGrayColor];
        self.day.text = @"00";
        self.hour.text = @"00";
        self.minite.text = @"00";
        self.second.text = @"00";
        self.day.textColor = [UIColor darkGrayColor];
        self.hour.textColor = [UIColor darkGrayColor];
        self.minite.textColor = [UIColor darkGrayColor];
        self.second.textColor = [UIColor darkGrayColor];
    }else{
        SMLog(@"我擦  时间判断 有漏网之鱼");
    }
    
}

- (void)refreshTimeLabelsWith:(NSString *)fromTime andToTime:(NSString *)toTime textColor:(UIColor *)color{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateToString = [dateFormatter dateFromString:toTime];
    NSDate *dateFromString = [dateFormatter dateFromString:fromTime];
    long timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970];
    //SMLog(@"timediff  %zd",timediff);
    if (timediff <= 0) {
        self.day.text = @"00";
        self.hour.text = @"00";
        self.minite.text = @"00";
        self.second.text = @"00";
    }else{
        int dayCount = (int)timediff / (60 * 60 * 24);
        self.day.text = [NSString stringWithFormat:@"%02zd",dayCount];
        int hour = (timediff % (60 * 60 * 24)) / (60 *60);
        self.hour.text = [NSString stringWithFormat:@"%02zd",hour];
        int minute = (timediff % (60 *60)) / 60;
        self.minite.text = [NSString stringWithFormat:@"%02zd",minute];
        int second = timediff % 60;
        self.second.text = [NSString stringWithFormat:@"%02zd",second];
    }
    
    if (color) {
        self.day.textColor = color;
        self.hour.textColor = color;
        self.minite.textColor = color;
        self.second.textColor = color;
    }
}

//时间str转时间戳
- (NSInteger)getTimeStampFromeTimeStr:(NSString *)timeStr{
    //设置时间显示格式:
    //    NSString* timeStr = @"2011-01-26 17:40:50";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSInteger timeStamp = (long)[date timeIntervalSince1970];
    SMLog(@"timeSp:%zd",timeStamp); //时间戳的值
    return timeStamp;
}

//获取当前时间
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:@"HH:mm"];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    return locationString;
}


//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

- (void)dealloc{
    SMLog(@"dealloc  KRefreshLastTimeNoti");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KRefreshLastTimNotification object:nil];
}

@end
