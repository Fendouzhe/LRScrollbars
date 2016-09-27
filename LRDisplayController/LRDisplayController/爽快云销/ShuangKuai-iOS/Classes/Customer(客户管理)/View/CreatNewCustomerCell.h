//
//  CreatNewCustomerCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreatNewCustomerBaseModel,CreatNewCustomerTextField;
@interface CreatNewCustomerCell : UITableViewCell
@property (nonatomic,strong) UILabel *detailLabel;/**< 尾部 */
@property (nonatomic,strong) CreatNewCustomerTextField *textField;/**< 文本输入框 */
@property (nonatomic,strong) CreatNewCustomerBaseModel *cellData;/**< cellData */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
