//
//  SMShoppingCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShoppingCellClickDelegate <NSObject>
//减
-(void)shoppingCellMinusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;
//加
-(void)shoppingCellPlusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;
//删
-(void)shoppingCellDeleteBtnClick:(Cart *)cart;
//选择
-(void)shoppingCellSelectBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters;
//商品图片
-(void)shoppingCellProductImageBtnClick:(Cart *)cart;

@end

@interface SMShoppingCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)Cart * cart;

@property (nonatomic,strong)id<SMShoppingCellClickDelegate> delegate;
@end
