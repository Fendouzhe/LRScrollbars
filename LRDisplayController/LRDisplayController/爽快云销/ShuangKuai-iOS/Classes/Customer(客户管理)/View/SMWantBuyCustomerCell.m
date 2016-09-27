//
//  SMWantBuyCustomerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMWantBuyCustomerCell.h"

@interface SMWantBuyCustomerCell ()

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UILabel *comPanyName;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *remarkOrTel;

@property (weak, nonatomic) IBOutlet UILabel *wantBuyLevel;

@property (weak, nonatomic) IBOutlet UILabel *customerLevel;

// 适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouBtnWidth;


@end

@implementation SMWantBuyCustomerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"wantBuyCustomerCell";
    SMWantBuyCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMWantBuyCustomerCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    self.comPanyName.text = customer.name;
    self.time.text = [self getTimeFromTimestamp:customer.createAt];
    if (customer.intro) {
        self.remarkOrTel.text = customer.intro;
    }else{
        self.remarkOrTel.text = customer.phone;
    }
    
    
    if (customer.buyRating == 0) {
        self.wantBuyLevel.text = @"A";
    }else if (customer.buyRating == 1){
        self.wantBuyLevel.text = @"B";
    }else if (customer.buyRating == 2){
        self.wantBuyLevel.text = @"C";
    }else{
        self.wantBuyLevel.text = @"";
    }
    
    if (customer.level == 0) {
        self.customerLevel.text = @"VIP客户";
    }else if (customer.level == 1){
        self.customerLevel.text = @"大型客户";
    }else if (customer.level == 2){
        self.customerLevel.text = @"中型客户";
    }else if (customer.level == 3){
        self.customerLevel.text = @"小型客户";
    }else{
        self.customerLevel.text = @"";
    }
    
    self.gouBtn.selected = customer.isSelected;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allChooseClick:) name:KWantBuyVCAllChoose object:nil];
}

- (void)allChooseClick:(NSNotification *)noti{
    
    NSString *str = noti.userInfo[KWantBuyVCAllChooseKey];
    BOOL select = str.integerValue;
    self.gouBtn.selected = select;
    self.customer.isSelected = select;

}

- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.customer.isSelected = sender.selected;
}

@end
