//
//  SMEditingTextField.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMEditingTextField.h"

@implementation SMEditingTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -20, bounds.size.height);//更好理解些
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -20, bounds.size.height);//更好理解些
    
    return inset;
    
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}


@end
