//
//  SMShelfDiscountCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalCoupon+CoreDataProperties.h"

@interface SMShelfDiscountCell : UITableViewCell
/**
 *  cell左上角的勾勾
 */
@property (weak, nonatomic) IBOutlet UIButton *gouBtn;
/**
 *  公司头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  公司名字
 */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
/**
 *  活动名字／描述
 */
@property (weak, nonatomic) IBOutlet UILabel *actionNameLabel;
/**
 *  有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

/**
 *  上面label
 */
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
/**
 *  下面label
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/**
 *  中间label
 */
@property (weak, nonatomic) IBOutlet UILabel *midLabel;

@property (nonatomic ,strong)FavoritesDetail *favDetail;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property(nonatomic,copy)FavoritesDetail * favDetail;

@property(nonatomic,strong)Coupon * coupon;

@end
