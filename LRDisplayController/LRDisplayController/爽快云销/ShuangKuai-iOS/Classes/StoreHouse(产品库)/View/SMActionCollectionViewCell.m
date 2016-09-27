//
//  SMActionCollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMActionCollectionViewCell.h"

@interface SMActionCollectionViewCell ()

/**
 *  当前时间
 */
@property (nonatomic ,copy)NSString *currentTimeStr;
/**
 *  活动结束时间
 */
@property (nonatomic ,copy)NSString *actionEndTimeStr;

@property (weak, nonatomic) IBOutlet UIButton *dayNumBtn1;

@property (weak, nonatomic) IBOutlet UIButton *dayNumBtn2;

@property (weak, nonatomic) IBOutlet UIButton *hourBtn1;

@property (weak, nonatomic) IBOutlet UIButton *hourBtn2;

@property (weak, nonatomic) IBOutlet UIButton *minuteBtn1;

@property (weak, nonatomic) IBOutlet UIButton *minuteBtn2;

@property (weak, nonatomic) IBOutlet UIButton *secBtn1;

@property (weak, nonatomic) IBOutlet UIButton *secBtn2;




@end

@implementation SMActionCollectionViewCell

+ (instancetype)actionCollectionViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMActionCollectionViewCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    [self addTimer];
}

- (void)addTimer{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(upDateTime) userInfo:nil repeats:YES];
    // 只要将定时器对象添加到运行循环，就会自动开启定时器
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)upDateTime{
    self.actionEndTimeStr = @"2016-10-1 23:59:59";
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:@"HH:mm"];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.currentTimeStr =[dateformatter stringFromDate:senddate];
    
    //    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    //    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];.
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:[dateformatter dateFromString:self.currentTimeStr] toDate:[dateformatter dateFromString:self.actionEndTimeStr] options:0];
    
    [self.dayNumBtn1 setTitle:[NSString stringWithFormat:@"%ld",(long)[d day] / 10] forState:UIControlStateNormal];
    [self.dayNumBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)[d day] % 10] forState:UIControlStateNormal];
    SMLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[d day] / 10]);
    
    [self.hourBtn1 setTitle:[NSString stringWithFormat:@"%ld",(long)[d hour] / 10] forState:UIControlStateNormal];
    [self.hourBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)[d hour] % 10] forState:UIControlStateNormal];
    
    [self.minuteBtn1 setTitle:[NSString stringWithFormat:@"%ld",(long)[d minute] / 10] forState:UIControlStateNormal];
    [self.minuteBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)[d minute] % 10] forState:UIControlStateNormal];
    
    [self.secBtn1 setTitle:[NSString stringWithFormat:@"%ld",(long)[d second] / 10] forState:UIControlStateNormal];
    [self.secBtn2 setTitle:[NSString stringWithFormat:@"%ld",(long)[d second] % 10] forState:UIControlStateNormal];
    
    SMLog(@"timer 还在抽风");
    SMLog(@"%@",d);
}

//- (void)setProduct:(Product *)product{
//    _product = product;
//    NSArray *arrAction = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
//    NSString *imageStr = arrAction[0];
//    [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//    
//    self.joinPersonNum.text = [NSString stringWithFormat:@"%zd人参加",product.peoples];
//}

//- (void)setActivity:(Activity *)activity{
//    _activity = activity;
//    SMLog(@"cell  activity  %@",activity.imagePaths);
//    NSArray *arrActivity = [NSString mj_objectArrayWithKeyValuesArray:activity.imagePaths];
//    NSString *imageStr = arrActivity[0];
//    SMLog(@"cell  imageStr  %@",activity.imagePaths);
////    [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//    [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        if (!error) {
//            SMLog(@"image 设置成功");
//        }else{
//            SMLog(@"image设置失败");
//        }
//    }];
//    SMLog(@"imageStr%@   activity%@ ",activity.imagePaths,activity);
//    self.joinPersonNum.text = [NSString stringWithFormat:@"%zd人参加",99];
//    SMLog(@"结束时间%zd",activity.endTime);
//    
//    [self refreshUI:activity];
//    
//}

- (void)dealloc{
    SMLog(@"dealloc -- SMActionCollectionViewCell");
    [self.timer invalidate];
    self.timer = nil;
}

-(void)refreshUI:(Activity *)activity
{
    NSArray *arrActivity = [NSString mj_objectArrayWithKeyValuesArray:activity.imagePaths];
    NSString *imageStr = arrActivity[0];
    //[self.actionImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    [self.actionImageView setShowActivityIndicatorView:YES];
    [self.actionImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
     self.joinPersonNum.text = [NSString stringWithFormat:@"%zd人参加",activity.peoples];
    

    //self.actionEndTimeStr =  [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",activity.endTime]];
    self.actionEndTimeStr = [self stringWithDate:activity.endTime];
    SMLog(@"imageStr.....%zd",activity.endTime);
    
}

-(NSString *)stringWithDate:(NSInteger)time
{
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    return [fmr stringFromDate:date];
}

@end
