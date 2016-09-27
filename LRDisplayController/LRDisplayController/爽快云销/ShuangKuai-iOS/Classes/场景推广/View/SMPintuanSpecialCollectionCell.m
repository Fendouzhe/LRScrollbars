//
//  SMPintuanSpecialCollectionCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPintuanSpecialCollectionCell.h"

@interface SMPintuanSpecialCollectionCell()

@property (strong, nonatomic)UIImageView *imageView;

@property (strong, nonatomic)UILabel *activiName;

@property (strong, nonatomic)UILabel *timeLabel;

@property (strong, nonatomic)UILabel *joinLabel;

@property (strong, nonatomic)UIView *bgView;

@property (nonatomic ,copy)NSString *actionEndTimeStr;/**< 活动截止时间 */

@property (nonatomic ,copy)NSString *actionStartTimeStr;/**< 活动开始时间 */

@property (nonatomic ,copy)NSString *currentTime;/**< 现在时间 */

@end

@implementation SMPintuanSpecialCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgView = [[UIView alloc] init];
        [self.contentView addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        _bgView = bgView;
        _bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _bgView.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bgView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        _bgView.layer.shadowRadius = 2;//阴影半径，默认3
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        //图片
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"220"];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(170*KMatch));
        }];
        
        //活动名
        _activiName = [[UILabel alloc] init];
        [self.contentView addSubview:_activiName];
        _activiName.font = KDefaultFontMiddleMatch;
        _activiName.textAlignment = NSTextAlignmentLeft;
        //_activiName.text = @"活动名";
        [_activiName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(25*KMatch));
        }];
        
        CGFloat with = self.width -2 * 10;
        
        //时间
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.font = KDefaultFont12Match;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        //_timeLabel.text = @"剩余00时00分00秒";
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activiName.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@(with*0.72));
            make.height.equalTo(@(25*KMatch));
        }];
        
        //已有多少人参加
        _joinLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_joinLabel];
        _joinLabel.font = KDefaultFont12Match;
        _joinLabel.textAlignment = NSTextAlignmentRight;
        _joinLabel.textColor = [UIColor darkGrayColor];
        //_joinLabel.text = @"已有多少人参加";
        [_joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activiName.mas_bottom);
            make.left.equalTo(_timeLabel.mas_right).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@(25*KMatch));
        }];
        
        //刷新通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLastTime) name:KRefreshLastTimNotification object:nil];
        
    }
    return self;
}


- (void)setMaster:(GroupBuyMaster *)master{
    _master = master;
    
    NSString *iconPath = master.imagePath;//[master.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
    [self.imageView setShowActivityIndicatorView:YES];
    [self.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"220"]];
    self.joinLabel.text = [NSString stringWithFormat:@"已有%zd人参团",master.buyNum];
    self.activiName.text = master.name;
    //SMLog(@"master.endTime %zd  master.startTime  %zd  master.name = %@",master.endTime,master.startTime,master.name);
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
///设置时间
- (void)setupTimeWithTip:(NSString *)tip tipColor:(UIColor *)tipColor day:(NSString *)day hour:(NSString *)hour minite:(NSString *)minite second:(NSString *)second timeColor:(UIColor *)timeColor{
    
    NSMutableAttributedString *muAttribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@天%@时%@分%@秒",tip,day,hour,minite,second] attributes:@{NSFontAttributeName:KDefaultFont12Match,NSForegroundColorAttributeName:[UIColor blackColor]}];
    [muAttribute setAttributes:@{NSForegroundColorAttributeName:tipColor} range:NSMakeRange(0, tip.length)];
    [muAttribute setAttributes:@{NSFontAttributeName:KDefaultFontMiddleMatch,NSForegroundColorAttributeName:timeColor} range:NSMakeRange(tip.length, 2)];
    [muAttribute setAttributes:@{NSFontAttributeName:KDefaultFontMiddleMatch,NSForegroundColorAttributeName:timeColor} range:NSMakeRange(tip.length+3, 2)];
    [muAttribute setAttributes:@{NSFontAttributeName:KDefaultFontMiddleMatch,NSForegroundColorAttributeName:timeColor} range:NSMakeRange(tip.length+3+3, 2)];
    [muAttribute setAttributes:@{NSFontAttributeName:KDefaultFontMiddleMatch,NSForegroundColorAttributeName:timeColor} range:NSMakeRange(tip.length+3+3+3, 2)];
    self.timeLabel.attributedText = muAttribute;
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
     
        [self refreshTimeLabelsWith:self.currentTime andToTime:self.actionStartTimeStr timeColor:[UIColor darkGrayColor] tip:@"距离活动开始还有" tipColor:KRedColorLight];
        
    }else if (self.master.clickState == 2){//活动正在进行
        
        [self refreshTimeLabelsWith:self.currentTime andToTime:self.actionEndTimeStr timeColor:KRedColorLight tip:@"剩余" tipColor:[UIColor darkGrayColor]];
        
    }else if (self.master.clickState == 3){//活动已结束

        [self setupTimeWithTip:@"剩余" tipColor:[UIColor darkGrayColor] day:@"00" hour:@"00" minite:@"00" second:@"00" timeColor:[UIColor darkGrayColor]];
    }else{
        SMLog(@"我擦  时间判断 有漏网之鱼");
    }
    
}

- (void)refreshTimeLabelsWith:(NSString *)fromTime andToTime:(NSString *)toTime timeColor:(UIColor *)color tip:(NSString *)tip tipColor:(UIColor *)tipColor{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateToString = [dateFormatter dateFromString:toTime];
    NSDate *dateFromString = [dateFormatter dateFromString:fromTime];
    long timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970];
    //SMLog(@"timediff  %zd",timediff);
    if (timediff <= 0) {

        [self setupTimeWithTip:tip tipColor:tipColor day:@"00" hour:@"00" minite:@"00" second:@"00" timeColor:color];
    }else{
        
        int dayCount = (int)timediff / (60 * 60 * 24);
        int hour = (timediff % (60 * 60 * 24)) / (60 *60);
        int minute = (timediff % (60 *60)) / 60;
        int second = timediff % 60;
        
        [self setupTimeWithTip:tip tipColor:tipColor day:[NSString stringWithFormat:@"%02zd",dayCount] hour:[NSString stringWithFormat:@"%02zd",hour] minite:[NSString stringWithFormat:@"%02zd",minute] second:[NSString stringWithFormat:@"%02zd",second] timeColor:color];
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
