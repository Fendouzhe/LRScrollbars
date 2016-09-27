//
//  SMNewProductDetaiCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewProductDetaiCell : UITableViewCell

@property (nonatomic ,strong)Favorites *fav;/**< <#注释#> */

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
