//
//  SMOrderManagerTopView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMOrderManagerTopViewDelegate <NSObject>

- (void)alreadyClosedDidClick;

- (void)alreadyDoneDidClick;

- (void)alreadyDispatchGoodsDidClick;

- (void)alreadyPayDidClick;

- (void)waitForPayDidClick;

- (void)allOrderDidClick;

- (void)refundDidClick;

@end

@interface SMOrderManagerTopView : UIView

@property (nonatomic ,weak)id<SMOrderManagerTopViewDelegate> delegate;

@property (nonatomic ,strong)UIScrollView *scrollView;

+ (instancetype)orderManagerTopView;

@end
