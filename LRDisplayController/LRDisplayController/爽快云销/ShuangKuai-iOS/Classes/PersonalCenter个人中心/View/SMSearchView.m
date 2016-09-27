//
//  SMSearchView.m
//  ShuangKuai-iOS
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchView.h"

@interface SMSearchView()


@end

@implementation SMSearchView


+ (instancetype)searchView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSearchView" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib
{

}

// 点击全部订单按钮
- (IBAction)totalOrder:(UIButton *)sender {
    
    sender.tag = -100;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击普通订单按钮
- (IBAction)ordinaryOrder:(UIButton *)sender {
    
    sender.tag = 0;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击团购订单按钮
- (IBAction)groupOrder:(UIButton *)sender {
    
    sender.tag = 1;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击活动订单按钮
- (IBAction)exerciseOrder:(UIButton *)sender {
    
    sender.tag = 2;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击秒杀订单按钮
- (IBAction)velocityOrder:(UIButton *)sender {
    
    sender.tag = 3;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击所有推广订单按钮
- (IBAction)popularizeOrder:(UIButton *)sender {
    
    sender.tag = 4;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        
        [self.delegate didSelectedType:sender.tag];
    }
}

// 点击了取消按钮
- (IBAction)cancel {
    
    if ([self.delegate respondsToSelector:@selector(cancelBtnClick)]) {
        
        [self.delegate cancelBtnClick];
    }
}


@end
