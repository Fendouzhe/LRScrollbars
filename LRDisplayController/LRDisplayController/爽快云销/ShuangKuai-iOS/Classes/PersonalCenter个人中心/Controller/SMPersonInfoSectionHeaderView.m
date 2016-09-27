//
//  SMPersonInfoSectionHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoSectionHeaderView.h"

@implementation SMPersonInfoSectionHeaderView

+(instancetype)sharedSectionHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.topView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1];
}

@end
