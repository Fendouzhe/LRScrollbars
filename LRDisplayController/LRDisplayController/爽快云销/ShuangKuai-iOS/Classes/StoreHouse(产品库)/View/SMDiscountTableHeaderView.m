//
//  SMDiscountTableHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscountTableHeaderView.h"

@interface SMDiscountTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation SMDiscountTableHeaderView

+ (instancetype)discountTableHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDiscountTableHeaderView" owner:nil options:nil] lastObject];
}

@end
