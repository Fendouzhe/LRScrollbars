//
//  SMDetailProductSection2Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailProductSection2Cell : UITableViewCell
/**
 *  颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
/**
 *  尺寸
 */
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
/**
 *  箭头
 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@property (weak, nonatomic) IBOutlet UIView *grayLine;

+ (instancetype)detailProductSection2Cell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
