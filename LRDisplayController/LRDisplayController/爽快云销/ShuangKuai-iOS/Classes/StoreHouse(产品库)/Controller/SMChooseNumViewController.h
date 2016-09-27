//
//  SMChooseNumViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMChooseNumViewControllerDelegate <NSObject>

- (void)userHasChooseNum;

@end

@interface SMChooseNumViewController : UIViewController

@property (nonatomic ,copy)NSString *productID;

@property (nonatomic ,assign)BOOL isBelongCounter;

@property (nonatomic ,weak)id<SMChooseNumViewControllerDelegate> delegate;

@end
