//
//  SMTweetToolbar.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMTweetToolbarDelegate <NSObject>

- (void)tweetToolBarDidClick:(UIButton *)btn;

@end

@interface SMTweetToolbar : UIView

/**
 *  点赞按钮
 */
@property (nonatomic, weak) UIButton *attitudeBtn;

@property (nonatomic ,weak)id<SMTweetToolbarDelegate> delegate;

@property (nonatomic ,strong)Tweet *tweet;

+ (instancetype)toolbar;


@end
