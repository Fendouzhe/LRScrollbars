//
//  CreatNewCustomerTextField.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CreatNewCustomerTextField.h"
#import "NSString+Extension.h"
@implementation CreatNewCustomerTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGFloat w = [self.placeholder textSizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(bounds.size.width, bounds.size.height)].width;
    CGFloat h = bounds.size.height;
    CGFloat x = self.frame.size.width - w;
    CGFloat y = (self.frame.size.height - h)*0.5;
    return CGRectMake(x, y, w, h);
}
@end
