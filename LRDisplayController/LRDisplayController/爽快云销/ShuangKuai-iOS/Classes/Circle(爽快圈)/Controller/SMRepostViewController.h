//
//  SMRepostViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMRepostViewControllerDelegate <NSObject>

- (void)recomposeBtnDidClick;

@end

@interface SMRepostViewController : UIViewController

@property (nonatomic ,strong)Tweet *tweet;

@property (nonatomic ,weak)id<SMRepostViewControllerDelegate> delegate;

@end
