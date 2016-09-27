//
//  SMCustomerTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalCustomer+CoreDataProperties.h"
@interface SMCustomerTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)refreshUI:(LocalCustomer *)customer;

@end
