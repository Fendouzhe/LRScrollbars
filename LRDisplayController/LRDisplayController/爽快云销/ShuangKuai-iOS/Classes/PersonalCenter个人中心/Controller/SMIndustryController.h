//
//  SMIndustryController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMIndustryControllerDelegate <NSObject>

- (void)sureBtnDidClick:(NSString *)title;

@end

@interface SMIndustryController : UIViewController

@property (nonatomic ,weak)id<SMIndustryControllerDelegate> delegate;

@end
