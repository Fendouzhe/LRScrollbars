//
//  SMShelfDiscountController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfDiscountControllerDelegate <NSObject>

#pragma mark   如果可以的话  这里直接把数据模型传过去
- (void)discountCellDidClick:(NSInteger)index;

@end

@interface SMShelfDiscountController : UIViewController

@property (nonatomic ,strong)NSMutableArray *arrDatas;

@property (nonatomic ,strong)Favorites *fav;

@property (nonatomic ,strong)NSMutableArray *arrCurrentIDS;

@property (nonatomic ,weak)id<SMShelfDiscountControllerDelegate> delegate;
/**
 *  属于柜台
 */
@property (nonatomic ,assign)BOOL isBelongCounter;

- (void)managerAllClick;

- (void)managerAllClickAgain;

-(void)loadDatas;

@end
