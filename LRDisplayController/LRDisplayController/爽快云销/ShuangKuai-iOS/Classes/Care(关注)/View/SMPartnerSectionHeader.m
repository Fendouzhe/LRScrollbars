//
//  SMPartnerSectionHeader.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPartnerSectionHeader.h"

@implementation SMPartnerSectionHeader

+ (instancetype)partnerSectionHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMPartnerSectionHeader" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.backgroundColor = KControllerBackGroundColor;
}

@end
