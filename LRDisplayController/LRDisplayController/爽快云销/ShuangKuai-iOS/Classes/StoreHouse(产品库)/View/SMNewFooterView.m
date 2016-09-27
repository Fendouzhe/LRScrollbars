//
//  SMNewFooterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewFooterView.h"

@interface SMNewFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *joinCartbtn;

@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;

@property (weak, nonatomic) IBOutlet UIView *goToCounterView;

@end

@implementation SMNewFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
//    self.joinCartbtn.layer.cornerRadius = SMCornerRadios *2;
//    self.joinCartbtn.clipsToBounds = YES;
    self.buyNowBtn.layer.cornerRadius = SMCornerRadios;
    self.buyNowBtn.clipsToBounds = YES;
    
    self.goToCounterView.hidden = YES;
}

//加入购物车
- (IBAction)joinCartbtnClick {
    if ([self.delegate respondsToSelector:@selector(joinBtnClick)]) {
        [self.delegate joinBtnClick];
    }
}
//立即购买
- (IBAction)buyNowBtnClick {
    if ([self.delegate respondsToSelector:@selector(buyNowBtnDidClick)]) {
        [self.delegate buyNowBtnDidClick];
    }
}
//进入柜台
- (IBAction)goToCounter {
    if ([self.delegate respondsToSelector:@selector(goToCounterDidClick)]) {
        [self.delegate goToCounterDidClick];
    }
}








//- (IBAction)joinAction:(UIButton *)sender {
//    SMLog(@"点击加入购物车");
//    if ([self.delegate respondsToSelector:@selector(joinBtnClick)]) {
//        [self.delegate joinBtnClick];
//    }
//}


@end
