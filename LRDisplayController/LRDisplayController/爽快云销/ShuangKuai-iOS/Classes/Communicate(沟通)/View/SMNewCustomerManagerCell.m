//
//  SMNewCustomerManagerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewCustomerManagerCell.h"

@interface SMNewCustomerManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *creatDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *StateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic ,strong)NSArray *arrStateMenu;
@end

@implementation SMNewCustomerManagerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID= @"newCustomerManagerCell";
    SMNewCustomerManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMNewCustomerManagerCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setCus:(Customer *)cus{
    _cus = cus;
    self.nameLabel.text = cus.fullname;
    self.creatDateLabel.text = [NSString stringWithFormat:@"该客户创建于%@",[self getTimeFromTimestamp:cus.createAt]];
    self.timeLabel.text = [self getTimeFromTimestamp:cus.createAt];
    self.StateLabel.text = self.arrStateMenu[cus.status];
    self.contentLabel.text = cus.intro;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.arrStateMenu = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"MM月dd号 HH:mm"];
    return [objDateformat stringFromDate: date];
}


@end
