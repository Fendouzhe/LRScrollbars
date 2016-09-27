//
//  SMSellLogTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalWorkLog+CoreDataProperties.h"
#import "LocalCustomer+CoreDataProperties.h"

@interface SMSellLogTableViewCell : UITableViewCell

+ (instancetype)sellLogTableViewCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)LocalWorkLog * localworklog;

-(void)refreshUIWithLocalworklog:(LocalWorkLog*)localworklog andWithLocalCustomer:(LocalCustomer*)localCustomer
;

@end
