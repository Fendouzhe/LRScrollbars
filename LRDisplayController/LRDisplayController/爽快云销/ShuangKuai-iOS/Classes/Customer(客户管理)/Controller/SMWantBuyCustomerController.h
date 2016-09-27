//
//  SMWantBuyCustomerController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@protocol SMWantBuyCustomerControllerDelegate <NSObject>

- (void)presentVc:(MFMessageComposeViewController *)vc;
- (void)dismissVc;

@end

@interface SMWantBuyCustomerController : UIViewController

@property(nonatomic,assign) BOOL selectorCustom;//是否选择顾客

@property (nonatomic,strong) UINavigationController *pushNav;/**< 导航控制器 */

@property (nonatomic ,weak)id<SMWantBuyCustomerControllerDelegate> delegate;/**< <#注释#> */

@property (nonatomic ,strong)UITableView *tableView;/**<  */

@end
