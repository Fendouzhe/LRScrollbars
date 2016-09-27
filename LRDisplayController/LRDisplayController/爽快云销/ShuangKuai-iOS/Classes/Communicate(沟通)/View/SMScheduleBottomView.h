//
//  SMScheduleBottomView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMScheduleBottomViewDelegate <NSObject>

- (void)scheduleBtnDidClick:(UIButton *)btn;

@end

@interface SMScheduleBottomView : UIView

@property (nonatomic ,weak)id<SMScheduleBottomViewDelegate> delegate;

+ (instancetype)scheduleBottomView;

@end
