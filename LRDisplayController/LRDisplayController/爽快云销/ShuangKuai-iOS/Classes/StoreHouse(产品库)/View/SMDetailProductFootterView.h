//
//  SMDetailProductFootterView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMDetailProductFootterViewDelegate <NSObject>

- (void)upBtnDidClick:(UIButton *)sender;

- (void)downBtnDidClick;

- (void)goToShelfBtnDidClick;

@end

@interface SMDetailProductFootterView : UIView

@property (nonatomic ,weak)id<SMDetailProductFootterViewDelegate> delegate;

@property(nonatomic,assign)BOOL isClick;

+ (instancetype)detailProductFootterView;

@end
