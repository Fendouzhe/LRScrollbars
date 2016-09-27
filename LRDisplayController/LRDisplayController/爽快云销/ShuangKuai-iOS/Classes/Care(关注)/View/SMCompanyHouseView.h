//
//  SMCompanyHouseView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCompanyHouseView : UIView

/**
 *  公司详细说明
 */
@property (nonatomic ,strong)UILabel *companyInfoLabel;

/**
 *  公司图标
 */
@property (nonatomic ,strong)UIButton *iconBtn;
/**
 *  公司名字label
 */
@property (nonatomic ,strong)UILabel *companyName;
/**
 *  处在第几行cell中
 */
@property (nonatomic ,assign)NSInteger indexNum;

@property(nonatomic,copy)NSString* Id;

+ (instancetype)companyHouseView;

@end
