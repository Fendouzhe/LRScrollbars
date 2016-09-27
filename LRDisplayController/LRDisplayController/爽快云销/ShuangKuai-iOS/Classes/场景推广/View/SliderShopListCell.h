//
//  SliderShopListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SliderShopListModel;
@interface SliderShopListCell : UITableViewCell
@property (nonatomic,strong) SliderShopListModel *cellData;/**< <#属性#> */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
