//
//  SMCustomerTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerTableViewCell.h"
#import "LocalWorkLog.h"

@interface SMCustomerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLable;

@property (weak, nonatomic) IBOutlet UILabel *rigthLable;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;

@end

@implementation SMCustomerTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"customerTableViewCell";
    SMCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCustomerTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)refreshUI:(LocalCustomer *)customer
{
    NSArray * array = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    self.leftLable.text = customer.fullname;
    self.rigthLable.text = array[[customer.status integerValue]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"该客户创建于%@",customer.startTime];
    
    NSArray * logArray = [LocalWorkLog MR_findByAttribute:@"id" withValue:customer.id];
    if (logArray.count>0) {
        LocalWorkLog * lastLog = [logArray lastObject];
        
        self.contentLabel.text = lastLog.content;
        self.timeLabel.text = lastLog.createAt;
       
    }else
    {
        self.contentLabel.text = @"暂无销售日志";
        self.timeLabel.text = nil;
        
    }
    
    
    
    
}

@end
