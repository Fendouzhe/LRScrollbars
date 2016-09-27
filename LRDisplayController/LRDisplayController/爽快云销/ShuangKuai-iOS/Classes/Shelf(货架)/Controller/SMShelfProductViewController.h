//
//  SMShelfProductViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfProductViewControllerDelegate <NSObject>

- (void)productCellDidClick:(NSInteger)index isBelongToCounter:(BOOL)isBelongCounter;

@end

@interface SMShelfProductViewController : UIViewController
/**
 *  数据源
 */
@property (nonatomic ,strong)NSMutableArray *arrProducts;

@property (nonatomic ,strong)Favorites *fav;

@property (nonatomic ,weak)id<SMShelfProductViewControllerDelegate> delegate;

@property (nonatomic,assign)BOOL isRootShelf;
/**
 *  属于柜台
 */
@property (nonatomic ,assign) BOOL isBelongCounter;

- (void)managerAllClick;

- (void)managerAllClickAgain;

- (void)loadDatas;

@end
