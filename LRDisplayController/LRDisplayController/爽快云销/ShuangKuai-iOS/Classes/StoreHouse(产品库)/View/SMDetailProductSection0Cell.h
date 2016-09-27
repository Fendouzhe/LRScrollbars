//
//  SMDetailProductSection0Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailProductSection0Cell : UITableViewCell

/**
 *  现在的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
/**
 *  邮费
 */
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
/**
 *  邮费
 */
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
/**
 *  佣金
 */
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
/**
 *  月销量
 */
@property (weak, nonatomic) IBOutlet UILabel *monthlySalesLabel;
/**
 *  库存量
 */
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
/**
 *  商品名
 */

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic ,copy)NSString *specPrice;/**< 选择完规格之后的价格 */

@property (nonatomic ,copy)NSString *specPrice2;/**< 选择完规格之后的价格  这个不回清空的 */
@property (weak, nonatomic) IBOutlet UIView *grayLine;



@property (nonatomic ,strong)Product *product;

+ (instancetype)detailProductSection0View;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
