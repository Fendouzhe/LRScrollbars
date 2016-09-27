//
//  CreatNewCustomerViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatNewCustomerViewControllerDelegate <NSObject>

@optional
-(void)creatNewCustomerSuccess;
-(void)saveNewCustomerSuccessWithCustomer:(Customer *)customer;
@end

@interface CreatNewCustomerViewController : UITableViewController
@property (nonatomic,strong) Customer *customer;/**< 客户资料 */
@property (nonatomic,weak) id<CreatNewCustomerViewControllerDelegate> delegate;/**<  */
@end
