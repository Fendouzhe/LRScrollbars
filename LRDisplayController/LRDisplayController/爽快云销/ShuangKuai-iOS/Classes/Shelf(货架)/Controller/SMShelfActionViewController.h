//
//  SMShelfActionViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfActionViewControllerDelegate <NSObject>

- (void)actionCellDidClick:(NSInteger)index;

@end

@interface SMShelfActionViewController : UIViewController

@property (nonatomic ,strong)NSMutableArray *arrDatas;

@property (nonatomic ,strong)Favorites *fav;

@property (nonatomic ,weak)id<SMShelfActionViewControllerDelegate> delegate;

@property (nonatomic ,strong)NSMutableArray *arrCurrentIDS;

- (void)managerAllClick;

- (void)managerAllClickAgain;

-(void)loadDatas;
@end
