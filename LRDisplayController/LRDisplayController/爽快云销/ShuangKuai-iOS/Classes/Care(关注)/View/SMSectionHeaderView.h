//
//  SMSectionHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSectionHeaderViewDelegate <NSObject>

- (void)sectionHeaderMoreBtnClick:(UIButton *)btn;

@end



@interface SMSectionHeaderView : UIView

@property (nonatomic ,weak)id<SMSectionHeaderViewDelegate> delegate;

@property (nonatomic ,copy)NSString *titleParameter;

- (instancetype)initWithString:(NSString *)title andBtnType:(recommendBtnType)recommendBtnType;

@end
