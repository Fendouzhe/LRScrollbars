//
//  SMProductTopView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProductTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic ,strong)NSArray *arrSkus;

@property (nonatomic ,strong)Product *product;

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@property (weak, nonatomic) IBOutlet UILabel *stockLabel;


+ (instancetype)productTopView;

@end
