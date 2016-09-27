//
//  SMSpecificationView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSpecificationView.h"

@implementation SMSpecificationView

+ (instancetype)specificationView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSpecificationView" owner:nil options:nil] lastObject];
}

@end
