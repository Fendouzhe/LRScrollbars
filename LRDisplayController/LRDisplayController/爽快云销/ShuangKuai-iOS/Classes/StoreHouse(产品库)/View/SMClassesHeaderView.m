//
//  SMClassesHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMClassesHeaderView.h"

@interface SMClassesHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *className;

@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;

@end

@implementation SMClassesHeaderView

+ (instancetype)classesHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setModel1:(SMClassesLevel1 *)model1{
    _model1 = model1;
    
    for (UITapGestureRecognizer *tap in [self gestureRecognizers]) {  //先移除之前的所有手势
        [self removeGestureRecognizer:tap];
    }
    
    self.className.text = model1.name;
    
    
    
    if (model1.arrLevel2s.count == 0) {
        self.checkAllBtn.hidden = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
        [self addGestureRecognizer:tap];
        
    }else{
        self.checkAllBtn.hidden = NO;
    }
}

- (void)headerViewTap{
    SMLog(@"headerViewTap");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"KSearchProductByClassNotiKey"] = self.model1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSearchProductByClassNoti" object:self userInfo:dict];
}
//查看全部
- (IBAction)checkAllClick:(UIButton *)sender {
    SMLog(@"checkAllClick ");
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"KSearchProductByClassNotiKey"] = self.model1;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSearchProductByClassNoti" object:self userInfo:dict];
    
    if ([self.delegate respondsToSelector:@selector(chectAllButtonClickWithHeaderView:)]) {
        [self.delegate chectAllButtonClickWithHeaderView:self];
    }
}

@end
