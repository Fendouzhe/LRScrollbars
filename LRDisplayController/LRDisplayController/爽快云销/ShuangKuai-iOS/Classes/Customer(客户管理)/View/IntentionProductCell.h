//
//  IntentionProductCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntentionProductModel;
@interface IntentionProductCell : UITableViewCell
@property (nonatomic,strong) Product *cellData;/**< <#属性#> */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
