//
//  SMNewProductSectionHeader.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewProductSectionHeader.h"

@interface SMNewProductSectionHeader ()

@property (nonatomic ,strong)UILabel *hotSaleLabel;

@end

@implementation SMNewProductSectionHeader

+ (instancetype)newProductSectionHeader{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *hotSaleLabel = [[UILabel alloc] init];
        self.hotSaleLabel = hotSaleLabel;
        [self addSubview:hotSaleLabel];
        hotSaleLabel.text = @"热销商品";
        hotSaleLabel.font = KDefaultFontBig;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.hotSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
}

@end
