//
//  SelectProductListMaskView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SelectProductListMaskView.h"

@interface SelectProductListMaskView ()
@property (nonatomic,strong) NSArray *titleArray;/**<  */
@end

@implementation SelectProductListMaskView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)]) {
//        self.alpha = 0.1;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(backgroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        MJWeakSelf
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

-(void)backgroundBtnClick:(UIButton *)btn{
    [self removeFromSuperview];
}

-(void)addButtonWithTitle:(NSArray *)titleArray{
    self.titleArray = titleArray;
    for (int i  = 0;i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = KDefaultFont;
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)setButtonWithTopFrame:(CGRect)topFrame{
    for (int i  = 0;i < self.titleArray.count; i++) {
        if (i == 0) {
            [self.subviews[i+1] setFrame:topFrame];
        }else{
            CGRect tempRect = topFrame;
            tempRect.origin.y = topFrame.size.height*i + topFrame.origin.y;
            [self.subviews[i+1] setFrame:tempRect];
        }
    }
}

-(void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(maskViewClickWithNumber:)]) {
        [self.delegate maskViewClickWithNumber:btn.tag];
    }
    [self removeFromSuperview];
}
@end
