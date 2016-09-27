//
//  SMCustomerDetailViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalCustomer+CoreDataProperties.h"

@protocol SMCustomerDetailViewControllerDelegate <NSObject>

- (void)refreshTableView;

@end

@interface SMCustomerDetailViewController : UIViewController

//@property(nonatomic,strong)LocalCustomer * localCustomer;

@property (nonatomic ,weak)id<SMCustomerDetailViewControllerDelegate> delegate;

@property (nonatomic ,strong)Customer *cus;

@end
