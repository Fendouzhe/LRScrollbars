//
//  SMDatePickerHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMDatePickerHeaderViewDelegate <NSObject>

- (void)topBtnDidClick:(UIButton *)btn;

@end

@interface SMDatePickerHeaderView : UIView

@property (nonatomic ,weak)id<SMDatePickerHeaderViewDelegate> delegate;

+ (instancetype)datePickerHeaderView;

@end
