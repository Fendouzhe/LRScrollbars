//
//  SMSystermMessageView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMSystermMessageView;

@protocol SMSystermMessageViewDelegate <NSObject>

- (void)clickButtonWithSystermMessageView:(SMSystermMessageView *)view;

@end

@interface SMSystermMessageView : UIView

@property(nonatomic,assign)NSInteger messageNum;

@property(nonatomic,weak)id<SMSystermMessageViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepLineHeight;

@property (weak, nonatomic) IBOutlet UIButton *sysButton;

+ (instancetype)systermMessageView;

@end
