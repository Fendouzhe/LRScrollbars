//
//  SMAlertView.h
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/7/31.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMAlertView;

@protocol SMAlertViewDelegate <NSObject>

///选择组图片
- (void)alertViewChooseImageButtonClick:(SMAlertView *)alertView;
///创建组
- (void)alertViewCreateButtonClick:(SMAlertView *)alertView;
///取消
- (void)alertViewCancelButtonClick:(SMAlertView *)alertView;

@end

@interface SMAlertView : UIView<UITextFieldDelegate>

@property(nonatomic,weak)id<SMAlertViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupImageTopConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageBtnTopConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFiledBottomConstrait;

@property(nonatomic,copy)NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIButton *creatButton;


+ (instancetype)alertView;

@end
