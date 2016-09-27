//
//  SMOldCustomerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOldCustomerCell.h"

@interface SMOldCustomerCell ()

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UILabel *customerName;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *orderCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouBtnWidth;
@end

@implementation SMOldCustomerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"oldCustomerCell";
    SMOldCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMOldCustomerCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    self.customerName.text = customer.name;
    self.time.text = [self getTimeFromTimestamp:customer.createAt];
    self.orderCount.text = [NSString stringWithFormat:@"成交订单数:%zd",customer.sumOrder];
    
}

//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gouBtnWidth.constant = 35 *SMMatchWidth;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allChooseClick:) name:KOldCustomerAllChoose object:nil];
}

- (void)allChooseClick:(NSNotification *)noti{
    
    NSString *str = noti.userInfo[KOldCustomerAllChooseKey];
    BOOL select = str.integerValue;
    self.gouBtn.selected = select;
    self.customer.isSelected = select;
    
}


- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.customer.isSelected = sender.selected;
}
@end
