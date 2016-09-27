//
//  RightImageButton.m
//  ButtonTest
//
//  Created by 宇中 on 16/6/22.
//  Copyright © 2016年 Youths. All rights reserved.
//

#import "RightImageButton.h"
#import "Masonry.h"
@implementation RightImageButton
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    
    CGFloat imageW = self.imageView.image.size.width;
    CGFloat imageH = self.imageView.image.size.height;
    CGFloat imageY = (self.frame.size.height - imageH)*0.5;
    CGFloat textW = self.titleLabel.frame.size.width;
    CGFloat textH = self.titleLabel.frame.size.height;
    CGFloat textY = (self.frame.size.height - textH) * 0.5;
    CGFloat textX = (self.frame.size.width - imageW - textW - 10)*0.5;
    CGFloat imageX = textX + textW + 10;
    
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.titleLabel.frame = CGRectMake(textX, textY, textW, textH);
    SMLog(@"%@,%@",self.imageView,self.titleLabel);
}


@end
