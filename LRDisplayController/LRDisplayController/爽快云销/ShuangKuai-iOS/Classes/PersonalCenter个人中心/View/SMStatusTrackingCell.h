//
//  SMStatusTrackingCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTrackInfo.h"

@interface SMStatusTrackingCell : UITableViewCell
/**
 *  红色灰色圆点
 */
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
/**
 *  上半部灰色竖线
 */
@property (weak, nonatomic) IBOutlet UIView *upGrayView;
/**
 *  下半部灰色竖线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  货送到了哪个位置
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic ,strong)SMTrackInfo *model;/**< 模型赋值 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)refreshUI:(NSDictionary *)dic;

@property(nonatomic,assign)CGFloat cellHeight;
@end
