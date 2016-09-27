//
//  SMShelfHotProductHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfHotProductHeaderViewDelegate <NSObject>

- (void)rightBtnDidClick;

@end

@interface SMShelfHotProductHeaderView : UIView

@property (nonatomic ,weak)id<SMShelfHotProductHeaderViewDelegate> delegate;

+ (instancetype)shelfHotProductHeaderView;

@end
