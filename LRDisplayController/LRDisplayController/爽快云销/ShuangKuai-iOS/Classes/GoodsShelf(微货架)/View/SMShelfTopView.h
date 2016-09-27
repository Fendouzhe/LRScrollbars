//
//  SMShelfTopView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/12.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfTopViewDelegate <NSObject>

- (void)shelfTopViewDidClick:(UIButton *)btn;

@end

@interface SMShelfTopView : UIView

@property (nonatomic ,weak)id<SMShelfTopViewDelegate> delegate;

/**
 *  我的货架
 */
@property (nonatomic ,strong)UIButton *myShelfBtn;

/**
 *  我的推广
 */
@property (nonatomic ,strong)UIButton *myPopularizeBtn;

+ (instancetype)shelfTopView;

@end
