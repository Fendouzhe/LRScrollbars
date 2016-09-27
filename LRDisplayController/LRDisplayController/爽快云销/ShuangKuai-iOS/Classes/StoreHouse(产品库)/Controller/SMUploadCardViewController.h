//
//  SMUploadCardViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SMUploadCardViewControllerDelegate <NSObject>

- (void)cardFrontUploadSeccess:(NSString *)token;
- (void)cardBackUploadSeccess:(NSString *)token;
- (void)cardHandUploadSeccess:(NSString *)token;

@end

@interface SMUploadCardViewController : UIViewController

@property (nonatomic ,weak)id<SMUploadCardViewControllerDelegate> delegate;

@end
