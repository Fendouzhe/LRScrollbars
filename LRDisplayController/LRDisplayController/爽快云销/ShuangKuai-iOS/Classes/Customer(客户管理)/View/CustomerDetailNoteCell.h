//
//  CustomerDetailNoteCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class CustomerDetailNoteFrameModel;
@interface CustomerDetailNoteCell : SWTableViewCell
@property (nonatomic,strong) CustomerDetailNoteFrameModel *cellData;/**< ViewFrame模型 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
