//
//  SMClassesCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMClassesCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tavbleView;

@property (nonatomic ,strong)NSArray *arrLevel2s;/**< 2级分类 */

@end
