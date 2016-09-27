//
//  SMDataStationCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMDataStation;
@interface SMDataStationCell : UITableViewCell

@property (nonatomic ,strong)SMDataStation *dataModel;/**< 数据 */

@property (nonatomic ,assign)NSInteger atRow; /**<  */

- (void)hideTopLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
