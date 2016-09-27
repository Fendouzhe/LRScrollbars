//
//  SMChangeShelfNameController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMChangeShelfNameControllerDelegate <NSObject>

- (void)saveSuccessName:(NSString *)name;

@end

@interface SMChangeShelfNameController : UIViewController

@property (nonatomic, copy) NSString *shelfID;

@property (nonatomic ,strong)NSMutableArray *arrProductDatas;

@property (nonatomic ,strong)NSMutableArray *arrActionDatas;

@property (nonatomic ,strong)NSMutableArray *arrDiscountDatas;

@property (nonatomic ,assign)NSInteger currentShelfNum;

@property (nonatomic ,weak)id<SMChangeShelfNameControllerDelegate> delegate;

@end
