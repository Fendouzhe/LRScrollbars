//
//  SMSection3Row1Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SMSection3Row1CellDelegate <NSObject>

- (void)selecteFirstItem;

@end

@class skuSelected;
@interface SMSection3Row1Cell : UITableViewCell
//选中的商品规格
@property (nonatomic ,copy)NSString *selectedStr;

@property (nonatomic ,assign)CGFloat cellHeight;

@property (nonatomic ,strong)skuSelected *skuS;
/**
 *  如果属于柜台模块的产品详情
 */
@property (nonatomic ,assign) BOOL belongToCounter;

@property (nonatomic ,assign)bool isDianxin;

@property (nonatomic ,assign)BOOL isBelongCounter;

//+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView andModel:(skuSelected *)SkuS;

@property (nonatomic ,weak)id<SMSection3Row1CellDelegate> delegate;/**< <#注释#> */


@end
