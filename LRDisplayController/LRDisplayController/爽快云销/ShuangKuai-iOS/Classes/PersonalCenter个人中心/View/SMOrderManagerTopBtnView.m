//
//  SMOrderManagerTopBtnView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderManagerTopBtnView.h"

@interface SMOrderManagerTopBtnView ()
@end

@implementation SMOrderManagerTopBtnView

- (instancetype)initWithStr:(NSString *)str image:(UIImage *)image{
    
    if (self = [super init]) {
        
        UIButton *icon = [[UIButton alloc] init];
        [self addSubview:icon];
        [icon setBackgroundImage:image forState:UIControlStateNormal];
        self.icon = icon;
        icon.userInteractionEnabled = NO;
       
        UILabel *name = [[UILabel alloc] init];
        name.text = str;
        [self addSubview:name];
        name.font = KDefaultFont;
        self.name = name;
    }
    return self;
}

- (void)showBlackName{
    self.name.textColor = [UIColor blackColor];
}

- (void)showRedName{
    self.name.textColor = KRedColorLight;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat wh = 30 *SMMatchHeight;
    NSNumber *width = [NSNumber numberWithFloat:wh];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(width);
        make.height.equalTo(width);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.icon.mas_centerX);
        make.top.equalTo(self.icon.mas_bottom).with.offset(10 *SMMatchHeight);
    }];
}


@end
