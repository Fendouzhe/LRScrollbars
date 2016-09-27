//
//  SMBoundingAliayCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMBoundingAliayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (nonatomic ,copy)NSString *name;/**< <#注释#> */

@property (nonatomic ,copy)NSString *holder;/**< <#注释#> */

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
