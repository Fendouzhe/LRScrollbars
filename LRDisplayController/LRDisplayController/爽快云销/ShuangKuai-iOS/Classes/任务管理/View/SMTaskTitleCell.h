//
//  SMTaskTitleCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMFatherTask;
@interface SMTaskTitleCell : UITableViewCell

@property (nonatomic ,strong)UITextField *inputField;/**< 标题输入栏 */

@property (nonatomic ,strong)SMFatherTask *fatherTask;/**< 父任务模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
