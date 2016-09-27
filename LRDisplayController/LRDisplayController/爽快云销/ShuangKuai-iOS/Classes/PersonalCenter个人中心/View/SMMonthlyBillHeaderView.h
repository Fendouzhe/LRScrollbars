//
//  SMMonthlyBillHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMMonthlyBillHeaderViewDelegate <NSObject>

- (void)monthChooseBtnDidClick;

@end

@interface SMMonthlyBillHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UIButton *monthBtn;

@property (weak, nonatomic) IBOutlet UILabel *totalInconLabel;

@property (weak, nonatomic) IBOutlet UILabel *compareLabel;

@property (nonatomic ,weak)id<SMMonthlyBillHeaderViewDelegate> delegate;

+ (instancetype)monthlyBillHeaderView;

@end
