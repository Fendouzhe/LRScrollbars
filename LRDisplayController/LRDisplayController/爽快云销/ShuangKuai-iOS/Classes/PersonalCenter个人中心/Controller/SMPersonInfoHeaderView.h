//
//  SMPersonInfoHeaderView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMPersonInfoHeaderView;

@protocol SMPersonInfoHeaderViewDelegate <NSObject>
//返回按钮点击
- (void)personInfoHeaderViewBackBtnClick;
//编辑按钮点击
- (void)personInfoHeaderViewEditBtnClick;
//设置按钮点击
- (void)personInfoHeaderViewSettingBtnClick;
//头像按钮点击
- (void)personInfoHeaderViewIconBtnClick:(SMPersonInfoHeaderView *)HeaderView;
//背景长按手势
- (void)personInfoHeaderViewBjImageViewLongPress:(SMPersonInfoHeaderView *)HeaderView;

@end

@interface SMPersonInfoHeaderView : UIView
//导航条
@property (weak, nonatomic) IBOutlet UIView *navigationView;
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
//简介
@property (weak, nonatomic) IBOutlet UILabel *instrolLabel;
//背景图
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
//设置按钮
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
//头像宽高约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthLayoutConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeightLayoutConstrait;

@property (nonatomic, assign) id<SMPersonInfoHeaderViewDelegate>delegate;

+(instancetype)sharedPersonInfoHeaderView;

@end
