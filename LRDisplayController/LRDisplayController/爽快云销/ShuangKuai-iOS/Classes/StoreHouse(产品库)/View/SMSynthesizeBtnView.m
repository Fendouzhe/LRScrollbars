//
//  SMSynthesizeBtnView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSynthesizeBtnView.h"

@interface SMSynthesizeBtnView ()

@end

@implementation SMSynthesizeBtnView

-(void)awakeFromNib
{
    
}

- (IBAction)priceAction:(UIButton *)sender {
    SMLog(@"点击按钮");
    //给个标识  知道是谁按得
    if (self.isPrice) {
        if ([_delegate respondsToSelector:@selector(priceBtnClick:)]) {
            [_delegate priceBtnClick:sender];
        }
    }else
    {
        if ([_delegate respondsToSelector:@selector(trustBtnClick:)]) {
            [_delegate trustBtnClick:sender];
        }
    }
}


@end
