//
//  SMConfirmPaymentCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMConfirmPaymentCellDelegate <NSObject>
//减
-(void)ConfirmPaymentCellMinusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;
//加
-(void)ConfirmPaymentCellPlusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;

//选择
-(void)ConfirmPaymentCellSelectBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;
//商品图片
//-(void)shoppingCellProductImageBtnClick:(Cart *)cart;

@end

@interface SMConfirmPaymentCell : UITableViewCell

+ (instancetype)cellWithTanleView:(UITableView *)tableView;

@property(nonatomic,strong)Cart * cart;

/**
 *  购买数量
 */
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

@property (nonatomic ,copy)NSString *specPrice;/**< <#注释#> */

@property (nonatomic ,copy)NSString *specName;/**< <#注释#> */

@property(nonatomic,strong)id<SMConfirmPaymentCellDelegate> delegate;
@end
