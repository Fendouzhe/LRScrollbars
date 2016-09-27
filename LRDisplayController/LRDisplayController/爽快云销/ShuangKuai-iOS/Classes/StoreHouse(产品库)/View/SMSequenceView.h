//
//  SMSequenceView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSequenceViewDelegate <NSObject>

- (void)topBtnDidClick:(UIButton *)btn viewTag:(int)tag;

- (void)bottomBtnDidClick:(UIButton *)btn viewTag:(int)tag;

@end

@interface SMSequenceView : UIView

@property (nonatomic ,weak)id<SMSequenceViewDelegate> delegate;

+ (instancetype)sequenceViewWithTopTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle;

@end
