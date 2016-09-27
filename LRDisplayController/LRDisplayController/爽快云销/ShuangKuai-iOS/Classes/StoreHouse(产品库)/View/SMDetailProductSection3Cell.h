//
//  SMDetailProductSection3Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailProductSection3Cell : UITableViewCell

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,strong)UIButton *rightBtn;

@property (nonatomic ,copy)NSString *specName;/**< 选择了的规格 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
