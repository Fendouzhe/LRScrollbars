//
//  SMDeadLineCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDeadLineCell.h"
#import "SMFatherTask.h"

@interface SMDeadLineCell ()

@property (nonatomic ,strong)UIView *grayView;/**< 灰色view */

@property (nonatomic ,strong)UIView *mainView;/**< 展示内容的view  */

@property (nonatomic ,strong)UILabel *leftLabel;/**< <#注释#> */

@property (nonatomic ,strong)UIImageView *rightIcon;/**<  */

@property (nonatomic ,strong)UIView *grayLine;/**< 最下面灰色横线 */


@end

@implementation SMDeadLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"deadLineCell";
    SMDeadLineCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SMDeadLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.grayView = [[UIView alloc] init];
        self.grayView.backgroundColor = KControllerBackGroundColor;
        [self.contentView addSubview:self.grayView];
        
        
        self.mainView = [[UIView alloc] init];
        [self.contentView addSubview:self.mainView];
        
        
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.text = @"截止时间";
        self.leftLabel.textColor = [UIColor blackColor];
        self.leftLabel.font = KDefaultFont;
        [self.mainView addSubview:self.leftLabel];
        
        //指向箭头
        self.rightIcon = [[UIImageView alloc] init];
        self.rightIcon.image = [UIImage imageNamed:@"zhixiang"];
        [self.mainView addSubview:self.rightIcon];
        
        //请选择任务截止时间label
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.text = @"请选择任务截止时间";
        self.rightLabel.textColor = [UIColor darkGrayColor];
        self.rightLabel.font = KDefaultFont;
        [self.mainView addSubview:self.rightLabel];
        
        //最下面灰色横线
        self.grayLine = [[UIView alloc] init];
        self.grayLine.backgroundColor = KGrayColorSeparatorLine;
        [self.contentView addSubview:self.grayLine];
        
    }
    return self;
}

- (void)setFatherTask:(SMFatherTask *)fatherTask{
    _fatherTask = fatherTask;
    
    if (fatherTask.schTime.integerValue == 0) { //进入子任务界面直接返回时，主任务界面的时间会显示1970-01-01  这个判断就是为了防止这个bug的出现
        return;
    }
    self.rightLabel.text = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%@",fatherTask.schTime]];
}

//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"YYYY-MM-dd HH:mm"];
    return [objDateformat stringFromDate: date];
}

- (void)setList:(SMSonTaskList *)list{
    _list = list;
    
    NSString *time = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%@",list.childSchedule.schTime]];
    
    if ([time isEqualToString:@""]) {
        self.rightLabel.text = @"请选择任务截止时间";
    }else{
        self.rightLabel.text = time;
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(@5);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.grayView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.left.equalTo(self.mainView.mas_left).with.offset(10);
    }];
    
    NSNumber *rightIconWH = [NSNumber numberWithFloat:15 *SMMatchHeight];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.right.equalTo(self.mainView.mas_right).with.offset(-10);
        make.width.equalTo(rightIconWH);
        make.height.equalTo(rightIconWH);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.right.equalTo(self.rightIcon.mas_left).with.offset(-5);
    }];
    
    [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
}
@end
