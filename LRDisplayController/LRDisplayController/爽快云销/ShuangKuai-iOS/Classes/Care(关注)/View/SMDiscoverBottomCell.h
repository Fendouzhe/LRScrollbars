//
//  SMDiscoverBottomCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMHotProductController;
@class SMHotActionController;
@class SMNewsController;

@interface SMDiscoverBottomCell : UITableViewCell

@property (nonatomic ,strong)SMHotProductController *vc1;

@property (nonatomic ,strong)SMHotActionController *vc2;

@property (nonatomic ,strong)SMNewsController *vc3;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
