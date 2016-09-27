//
//  SMProductView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductView.h"

@interface SMProductView ()

//@property (nonatomic ,strong)UIImageView *imageView;

@end

@implementation SMProductView

+(instancetype)productView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KControllerBackGroundColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.image = [UIImage imageNamed:@"产品2"];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat marginUnder = 10;    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-marginUnder);
    }];
}
@end
