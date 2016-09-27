//
//  SMNewHotProductCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewHotProductCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,strong)FavoritesDetail *favoritesDetail;

@end
