//
//  SMActiveQcodeView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMActiveQcodeView;

@protocol SMActiveQcodeViewDelegate <NSObject>
///保存到相册
- (void)saveToPhotoWithSMActiveQcodeView:(SMActiveQcodeView *)QcodeView;
///隐藏
- (void)hiddenWithSMActiveQcodeView:(SMActiveQcodeView *)QcodeView;

@end

@interface SMActiveQcodeView : UIView

@property (weak, nonatomic) id<SMActiveQcodeViewDelegate>delegate;
///二维码背景
@property (weak, nonatomic) IBOutlet UIView *qcodeView;
///产品名称
@property (weak, nonatomic) IBOutlet UILabel *productName;
///二维码
@property (weak, nonatomic) IBOutlet UIImageView *qcodeImageView;
///二维码
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
///活动二维码
@property (weak, nonatomic) IBOutlet UILabel *activeTitleLabel;
///保存到相册
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
///隐藏
@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;
///上间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstrait;
///左间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstrait;
///下间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginConstrait;
///右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginConstrait;
///二维码图片高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qcodeImageHeightConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qcodeLabelHeightConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonHeightConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddenButtonHeightConstrait;

+(instancetype)activeQcodeView;


@end
