//
//  SMCounterHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCounterHeaderViewDelegate <NSObject>

- (void)shareBtnDidClick;
- (void)iconDidClick;

@end


@interface SMCounterHeaderView : UIView

+ (instancetype)counterHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *counterName;

@property (weak, nonatomic) IBOutlet UILabel *shopKeeper;

@property (nonatomic ,weak)id<SMCounterHeaderViewDelegate> delegate;

@property (nonatomic ,copy)NSString *shelfName;

@property (weak, nonatomic) IBOutlet UIImageView *bjIcon;

@end
