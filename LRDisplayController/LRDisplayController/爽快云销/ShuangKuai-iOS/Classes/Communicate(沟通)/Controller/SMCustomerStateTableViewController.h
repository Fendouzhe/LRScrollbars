//
//  SMCustomerStateTableViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Typeblock)(NSInteger);

@interface SMCustomerStateTableViewController : UITableViewController

@property(nonatomic,strong)Typeblock  blcok;


@end
