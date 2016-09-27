//
//  CustomerDetailInfoHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailInfoHeaderView.h"

@interface CustomerDetailInfoHeaderView ()
@property (nonatomic,strong) UILabel *nameLabel;/**< 名称 */
@end

@implementation CustomerDetailInfoHeaderView

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:115/255.0 blue:131/255.0 alpha:1];
    }
    return self;
}

-(void)setCustomer:(Customer *)customer{
    _customer = customer;
    self.nameLabel.text = customer.name;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.nameLabel.text.length) {
        self.nameLabel.text= @" ";
    }
    [self.nameLabel sizeToFit];
    CGFloat nameLabelW = self.frame.size.width;
    CGFloat nameLabelH = self.nameLabel.frame.size.height;
    CGFloat nameLabelX = 0;
    CGFloat nameLabelY = (self.frame.size.height - nameLabelH)*0.5;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
}

@end
