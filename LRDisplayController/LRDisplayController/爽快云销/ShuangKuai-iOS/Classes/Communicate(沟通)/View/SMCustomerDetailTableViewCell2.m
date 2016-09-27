//
//  SMCustomerDetailTableViewCell2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerDetailTableViewCell2.h"

@interface SMCustomerDetailTableViewCell2 ()

@property(nonatomic,strong)UIImageView * iconImageView;

@property(nonatomic,strong)UILabel * nameLabel;

@end

@implementation SMCustomerDetailTableViewCell2

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"customerDetailTableViewCell2";
    SMCustomerDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMCustomerDetailTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //添加控件,头像
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconImageView = iconView;
        iconView.image = [UIImage imageNamed:@"touxiang"];
        [self.contentView addSubview:iconView];
        iconView.layer.cornerRadius = 22.5;
        iconView.clipsToBounds = YES;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.width.equalTo(@45);
            make.height.equalTo(@45);
        }];
        
        //用户名
        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        nameLabel.text = @"我是谁";
        nameLabel.font = KDefaultFontBig;
        [self.contentView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconView.mas_centerY);
            make.left.equalTo(iconView.mas_right).with.offset(10);
        }];
        
        //时间
//        UILabel *timeLabel = [[UILabel alloc] init];
//        timeLabel.text = @"11月11日 20:20";
//        timeLabel.textColor = KGrayColor;
//        timeLabel.font = [UIFont systemFontOfSize:10];
//        [self.contentView addSubview:timeLabel];
//        
//        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            //                make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(self.contentView.mas_top).with.offset(10);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
//        }];
        
//        //发布的内容。
//        UILabel *contentLabel = [[UILabel alloc] init];
//        self.comment = @"今天任务完成的不错，加油，你是最棒的！今天任务完成的不错，加油，你是最棒的！今天任务完成的不错，加油，你是最棒的！今天任务完成的不错，加油，你是最棒的！今天任务完成的不错，加油，你是最棒的！今天任务完成的不错，加油，你是最棒的！";
//        contentLabel.text = self.comment;
//        contentLabel.textColor = [UIColor darkGrayColor];
//        contentLabel.font = [UIFont systemFontOfSize:12];
//        contentLabel.textAlignment = NSTextAlignmentLeft;
//        contentLabel.numberOfLines = 0;
//        [self.contentView addSubview:contentLabel];
//        
//        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.contentView.mas_left).with.offset(10);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
//            make.top.equalTo(iconView.mas_bottom).with.offset(10);
//        }];
       
        //时间
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"11月11日 20:20";
        _timeLabel.textColor = KGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        //发布的内容。
        self.commentLable = [[UILabel alloc] init];

        self.commentLable.textColor = [UIColor darkGrayColor];
        self.commentLable.font = [UIFont systemFontOfSize:12];
        self.commentLable.textAlignment = NSTextAlignmentLeft;
        self.commentLable.numberOfLines = 0;
        [self.contentView addSubview:self.commentLable];
        
        [self.commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.top.equalTo(iconView.mas_bottom).with.offset(10);
        }];
        
 //暂时作为只有自己能发表。。。。 自己ID 、name
        NSData * imagedata =  [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        iconView.image = [UIImage imageWithData:imagedata];
        
     
        nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        
    }
    return self;
}

- (void)setLog:(WorkLog *)log{
    _log = log;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:log.portrait] placeholderImage:[UIImage imageNamed:@"220"]];
    self.nameLabel.text = log.userName;
    self.comment = log.content;
    self.commentLable.text = log.content;
    self.timeLabel.text = [self getTimeFromTimestamp:log.createAt];
}

- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}

-(void)setLocalworklog:(LocalWorkLog *)localworklog
{
    self.comment = localworklog.content;
    self.commentLable.text = self.comment;
    
    self.timeLabel.text = localworklog.createAt;
}

-(void)setLocalScheduleCompose:(LocalScheduleCompose *)localScheduleCompose
{
    self.comment = localScheduleCompose.content;
    self.commentLable.text = self.comment;
    
    self.timeLabel.text = localScheduleCompose.createAt;
}

-(void)setScheduleDetail:(ScheduleDetail *)scheduleDetail{
    _scheduleDetail = scheduleDetail;
    
    self.comment =scheduleDetail.content;
    
    SMLog(@"content =    %@",scheduleDetail.content);
    
    self.commentLable.text = scheduleDetail.content;
    
    
    [self.iconImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:scheduleDetail.uPortrait] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:SDWebImageRefreshCached progress:nil completed:nil];
    self.nameLabel.text = scheduleDetail.uName;
    self.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",scheduleDetail.createAt]];
}
@end
