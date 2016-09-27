//
//  SMOldCustomerController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@protocol SMOldCustomerControllerDelegate <NSObject>

- (void)presentVc2:(MFMessageComposeViewController *)vc;
- (void)dismissVc2;

@end

@interface SMOldCustomerController : UIViewController

@property(nonatomic,assign) BOOL selectorCustom;//是否选择顾客

@property (nonatomic,strong) UINavigationController *pushNav;/**< 导航控制器 */

@property (nonatomic ,weak)id<SMOldCustomerControllerDelegate> delegate;/**< <#注释#> */

@property (nonatomic ,strong)UITableView *tableView;/**<  */
@end
