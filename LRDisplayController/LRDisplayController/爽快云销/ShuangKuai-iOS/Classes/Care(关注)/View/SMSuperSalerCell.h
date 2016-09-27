//
//  SMSuperSalerCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSuperSalerCellDelegate <NSObject>

- (void)superMansDidClick;

@end

@interface SMSuperSalerCell : UITableViewCell

@property (nonatomic ,weak)id<SMSuperSalerCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic ,copy)NSMutableArray * datasArray;

@end
