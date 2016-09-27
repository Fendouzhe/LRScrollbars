//
//  SMSonTaskCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSonTaskList.h"
#import "SMSonTaskListFrame.h"

@interface SMSonTaskCell : UITableViewCell

@property (nonatomic ,strong)SMSonTaskListFrame *listF;/**< <#注释#> */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
