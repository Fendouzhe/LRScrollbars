//
//  SMQuickSalesManagementCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMQuickSalesManagementCellDelegate <NSObject>

- (void)myOrderBtnBtnDidClick;

- (void)myIncomeBtnDidClick;

- (void)myCounterDidClick;

- (void)partnerBtnDidClick;

- (void)discountBtnDidClick;

- (void)signInBtnDidClick;

- (void)customerBtnDidClick;

- (void)taskBtnDidClick;

- (void)connectBtnDidClick;

@end

@interface SMQuickSalesManagementCell : UITableViewCell

@property (nonatomic ,assign)CGFloat cellHeight;

@property (nonatomic ,weak)id<SMQuickSalesManagementCellDelegate> delegate;

//我的订单
@property (nonatomic ,strong)UIButton *myOrderBtn;

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@end
