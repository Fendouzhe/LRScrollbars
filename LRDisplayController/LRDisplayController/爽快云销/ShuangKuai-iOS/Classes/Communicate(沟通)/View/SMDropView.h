//
//  SMDropView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/7.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMDropView;
@protocol SMDropViewDelegate <NSObject>
@optional

- (void)dropdownMenuDidDismiss:(SMDropView *)menu;

- (void)dropdownMenuDidShow:(SMDropView *)menu;

- (void)addBtnDidClick;

- (void)deleteBtnDidClick;

-(void)groupBtnDidClick;

@end

@interface SMDropView : UIView

/**
 *  灰色view 内部的view
 */
@property (nonatomic ,strong)UIView *content;

@property (nonatomic ,strong)UIViewController *contentController;

/**
 *  增加商品
 */
@property (nonatomic ,strong)UIButton *addBtn;

@property (nonatomic ,weak)id<SMDropViewDelegate> delegate;

+ (instancetype)menu;

- (void)showFrom:(UIView *)from;

- (void)dismiss;


@end
