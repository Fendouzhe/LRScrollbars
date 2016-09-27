//
//  SMCreatNewCustomerView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/20.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCreatNewCustomerView.h"

@implementation SMCreatNewCustomerView

+ (instancetype)newCustomerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCreatNewCustomerView" owner:nil options:nil] lastObject];
}


@end
