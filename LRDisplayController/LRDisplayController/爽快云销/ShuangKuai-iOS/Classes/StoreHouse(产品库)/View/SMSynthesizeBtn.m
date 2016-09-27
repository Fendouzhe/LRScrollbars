//
//  SMSynthesizeBtn.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSynthesizeBtn.h"


@interface SMSynthesizeBtn ()

@end

@implementation SMSynthesizeBtn

+ (instancetype)synthesizeBtn{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSynthesizeBtn" owner:nil options:nil] lastObject];
}

@end
