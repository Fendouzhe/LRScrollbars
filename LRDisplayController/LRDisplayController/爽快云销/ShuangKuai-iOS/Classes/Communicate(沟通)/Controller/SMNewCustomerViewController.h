//
//  SMNewCustomerViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMNewCustomerViewControllerDelegate <NSObject>

- (void)refreshData;

@end

@interface SMNewCustomerViewController : UIViewController

@property (nonatomic ,weak)id<SMNewCustomerViewControllerDelegate> delegate;

@end
