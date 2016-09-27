//
//  SMSearchFooterView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSearchFooterViewDelegate <NSObject>

- (void)clearRecordBtnDidClick;

@end

@interface SMSearchFooterView : UIView

@property (nonatomic ,weak)id<SMSearchFooterViewDelegate> delegate;

+ (instancetype)searchFooterView;

@end
