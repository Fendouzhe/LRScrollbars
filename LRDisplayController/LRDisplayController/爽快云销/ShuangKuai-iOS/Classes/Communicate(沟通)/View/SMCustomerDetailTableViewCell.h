//
//  SMCustomerDetailTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCustomerDetailTableViewCellDelegate <NSObject>

- (void)moreBtnDidClick:(UIButton *)btn;

@end

@interface SMCustomerDetailTableViewCell : UITableViewCell

@property (nonatomic ,weak)id<SMCustomerDetailTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
