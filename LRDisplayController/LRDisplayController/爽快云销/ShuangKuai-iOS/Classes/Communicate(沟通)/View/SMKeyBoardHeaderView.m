//
//  SMKeyBoardHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMKeyBoardHeaderView.h"

@implementation SMKeyBoardHeaderView

+ (instancetype)keyBoardHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMKeyBoardHeaderView" owner:nil options:nil] lastObject];
}

@end
