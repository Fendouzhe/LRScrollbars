//
//  SMShelfTemplateViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/7.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMShelfTemplateViewController : UIViewController

/**
 *  我的微货架所显示的tableView
 */
@property (nonatomic ,strong)UITableView *shelfTableView;
/**
 *  我的微推广所显示的tableView
 */
@property (nonatomic ,strong)UITableView *extensionTableView;

@end
