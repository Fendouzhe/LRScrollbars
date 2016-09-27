//
//  SMSearchView.h
//  ShuangKuai-iOS
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSearchViewDelegate <NSObject>

// 点击取消按钮通知外界做操作
- (void)cancelBtnClick;

- (void)didSelectedType:(NSInteger)type;

@end

@interface SMSearchView : UIView

+ (instancetype)searchView;

@property (nonatomic, weak) id<SMSearchViewDelegate> delegate;

@end
