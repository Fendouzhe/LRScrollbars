//
//  SMCommissionRecordHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCommissionRecordHeaderViewDelegate <NSObject>

- (void)monthlyBillBtnDidClick:(NSString *)year andMonth:(NSString *)month;

@end

@interface SMCommissionRecordHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (nonatomic ,weak)id<SMCommissionRecordHeaderViewDelegate> delegate;

+ (instancetype)commissionRecordHeaderView;

@end
