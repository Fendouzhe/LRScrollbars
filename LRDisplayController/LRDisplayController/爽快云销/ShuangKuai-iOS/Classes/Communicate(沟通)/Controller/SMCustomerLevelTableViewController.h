//
//  SMCustomerLevelTableViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^levelBlock)(NSInteger);

@interface SMCustomerLevelTableViewController : UITableViewController

@property(nonatomic,strong)levelBlock levelblock;

@property(nonatomic,assign)NSInteger levelInteger;

@end
