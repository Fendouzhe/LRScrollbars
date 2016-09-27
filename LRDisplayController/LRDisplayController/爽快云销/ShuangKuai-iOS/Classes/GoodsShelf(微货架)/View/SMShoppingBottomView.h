//
//  SMShoppingBottomView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShoppingBottomViewClickDelegate <NSObject>

-(void)shoppingBottomViewAllSelectedClick:(UIButton *)btn;

-(void)shoppingBottomViewAccountClick:(UIButton *)btn;

@end

@interface SMShoppingBottomView : UIView

+ (instancetype)shoppingBottomView;

@property(nonatomic,copy)NSArray * array;

@property(nonatomic,strong)id<SMShoppingBottomViewClickDelegate> delegate;
@end
