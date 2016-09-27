//
//  SMJumpUpView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMProductTopView;
@protocol SMJumpUpViewDeledate <NSObject>

- (void)sureBtnDidClick:(NSInteger)buyCount andPhoneNum:(NSString *)phoneNum;

- (void)specificationsDidClick:(ProductSpec *)spec;

@end

@class skuSelected;
@interface SMJumpUpView : UIView

//+ (instancetype)jumpUpViewWithModle:(skuSelected *)skus;

@property (nonatomic ,strong)SMProductTopView *topView;

@property (nonatomic ,weak)id<SMJumpUpViewDeledate> deledate;

@property (nonatomic ,strong)NSArray *arrSkus;

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,assign)BOOL isDianxin;

@property (nonatomic ,assign)BOOL isBelongCounter;

//@property (nonatomic ,assign)BOOL isNotCounter;

//@property (nonatomic ,strong)skuSelected *skus;

//- (instancetype)initWithModle:(skuSelected *)skus;

@end
