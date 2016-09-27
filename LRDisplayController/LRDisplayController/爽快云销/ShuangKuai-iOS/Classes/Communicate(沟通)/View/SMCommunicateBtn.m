//
//  SMCommunicateBtn.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommunicateBtn.h"

@implementation SMCommunicateBtn

+(instancetype)communicateBtn{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCommunicateBtn" owner:nil options:nil] lastObject];
}

+ (SMCommunicateBtn *)communicateBtnWithImage:(NSString *)imageName title:(NSString *)title{
    
    SMCommunicateBtn *btn = [SMCommunicateBtn communicateBtn];
    [btn.functionBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.founctionTitle.text = title;
    
    return btn;
}

@end
