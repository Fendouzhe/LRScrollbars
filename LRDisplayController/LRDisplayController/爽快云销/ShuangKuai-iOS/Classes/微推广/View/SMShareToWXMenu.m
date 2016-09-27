//
//  SMShareToWXMenu.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/30.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShareToWXMenu.h"

@implementation SMShareToWXMenu

+ (instancetype)shareToWXMenu{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMShareToWXMenu" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
    self.layer.cornerRadius = SMCornerRadios;
    self.clipsToBounds = YES;
}

- (void)click{
    if ([self.delegate respondsToSelector:@selector(wxMenuDidClick)]) {
        [self.delegate wxMenuDidClick];
    }
}
@end
