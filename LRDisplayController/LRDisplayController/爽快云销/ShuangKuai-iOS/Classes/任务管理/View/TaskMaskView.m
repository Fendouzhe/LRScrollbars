//
//  TaskMaskView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskMaskView.h"

@implementation TaskMaskView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        UIButton *backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backGroundButton.backgroundColor = [UIColor clearColor];
        [backGroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGroundButton];
        [backGroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)backgroundButtonClick{
    [self removeFromSuperview];
}

-(void)addTextButtonWithArrayText:(NSArray *)array withPosition:(int)position{
    switch (position) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            for (int i = 0; i<array.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = KDefaultFont;
                [btn setTitle:array[i] forState:UIControlStateNormal];
                CGFloat btnW = 100;
                CGFloat btnH = 30;
                CGFloat btnX = KScreenWidth*0.5 - btnW*0.5;
                CGFloat btnY = 64+45*SMMatchWidth + 40*SMMatchWidth +i*btnH;
                [self addSubview:btn];
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                btn.tag = i;
                [btn addTarget:self action:@selector(selectButtonClickWithNumber:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case 2:
        {
            for (int i = 0; i<array.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = KDefaultFont;
                [btn setTitle:array[i] forState:UIControlStateNormal];
                CGFloat btnW = 100;
                CGFloat btnH = 30;
                CGFloat btnX = KScreenWidth*3/4 - btnW*0.5+25;
                CGFloat btnY = 64+45*SMMatchWidth + 40*SMMatchWidth +i*btnH;
                [self addSubview:btn];
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                btn.tag = i;
                [btn addTarget:self action:@selector(selectButtonClickWithNumber:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        default:
            break;
    }
}

-(void)selectButtonClickWithNumber:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectButtonWithNumber:)]) {
        [self.delegate selectButtonWithNumber:(int)btn.tag];
    }
    [self removeFromSuperview];
}

@end
