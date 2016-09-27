//
//  CustomerLevelViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerLevelViewControllerDelegate <NSObject>

@optional
-(void)chooseCustomerLevel:(NSString *)level;
@end

@interface CustomerLevelViewController : UITableViewController
@property (nonatomic,weak) id<CustomerLevelViewControllerDelegate> delegate;/**<  */
@end
