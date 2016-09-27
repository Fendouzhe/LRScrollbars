//
//  SMMyInComeTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyInComeTableViewCell.h"

@implementation SMMyInComeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(NSString * )imageName andTitle:(NSString *)title{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView * view = [[UIView alloc]initWithFrame:self.contentView.frame];
    [self.contentView addSubview:view];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 25, 25)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.centerY = self.contentView.center.y;
    [view addSubview:imageView];
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(38, 0, KScreenWidth-60, 32)];
    lable.text = title;
    lable.centerY = view.centerY;
    [view addSubview:lable];
    
}
@end
