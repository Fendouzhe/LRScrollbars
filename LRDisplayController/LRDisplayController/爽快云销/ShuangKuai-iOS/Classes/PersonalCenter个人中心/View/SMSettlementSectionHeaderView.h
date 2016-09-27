//
//  SMSettlementSectionHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSettlementSectionHeaderViewDelegate <NSObject>

- (void)commissionBtnDidClick;

@end

@interface SMSettlementSectionHeaderView : UIView

+ (instancetype)settlementSectionHeaderView;

@property (nonatomic ,weak)id<SMSettlementSectionHeaderViewDelegate> delegate;
@end
