//
//  SMNewRigthItemVIew.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMNewRigthItemVIewDelegate <NSObject>

- (void)searchBtnDidClick;

- (void)BtnDidClick:(UIButton *)btn;

@end

@interface SMNewRigthItemVIew : UIView

@property (nonatomic ,weak)id<SMNewRigthItemVIewDelegate> delegate;

//+ (instancetype)rightItemView;

+ (instancetype)initWithBarButtonItemsImage:(NSString *)rigthImageName andleftImage:(NSString *)leftImageName;

+ (instancetype)initWithBarButtonItemsName:(NSString *)rigthName andleftImage:(NSString *)leftImageName;

/**
 *  带文字的。
 */
@property(nonatomic,assign)BOOL isNameString;

@end
