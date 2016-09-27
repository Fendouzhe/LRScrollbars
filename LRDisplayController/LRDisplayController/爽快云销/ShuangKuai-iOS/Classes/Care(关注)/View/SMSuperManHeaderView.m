//
//  SMSuperManHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/8/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSuperManHeaderView.h"

@interface SMSuperManHeaderView()


@end

@implementation SMSuperManHeaderView

+ (instancetype)superManHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.firstIconToTop.constant -= 0.45;
    [self layoutIfNeeded];
    
    self.firstLabel.textColor = KRedColorLight;
    self.secondLabel.textColor = KRedColorLight;
    self.threeLabel.textColor = KRedColorLight;
    
    self.firstIconImage.layer.cornerRadius = self.firstIconImage.width * 0.5;
    self.secondIconImage.layer.cornerRadius = self.secondIconImage.width * 0.5;
    self.threeIconImage.layer.cornerRadius = self.threeIconImage.width * 0.5;
    
    self.firstIconImage.layer.masksToBounds = YES;
    self.secondIconImage.layer.masksToBounds = YES;
    self.threeIconImage.layer.masksToBounds = YES;
    
    self.firstIconImage.userInteractionEnabled = YES;
    self.secondIconImage.userInteractionEnabled = YES;
    self.threeIconImage.userInteractionEnabled = YES;
    
    self.firstIconImage.tag = 0;
    self.secondIconImage.tag = 1;
    self.threeIconImage.tag = 2;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.firstIconImage addGestureRecognizer:tap1];
    [self.secondIconImage addGestureRecognizer:tap2];
    [self.threeIconImage addGestureRecognizer:tap3];
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(superManHeaderViewIconViewClick:)]) {
        [self.delegate superManHeaderViewIconViewClick:_userArr[imageView.tag]];
    }
}

- (void)setUserArr:(NSMutableArray *)userArr{
    _userArr = userArr;
    
    [self.firstIconImage sd_setImageWithURL:[NSURL URLWithString:[userArr[0] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    [self.secondIconImage sd_setImageWithURL:[NSURL URLWithString:[userArr[1] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    [self.threeIconImage sd_setImageWithURL:[NSURL URLWithString:[userArr[2] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    
    self.firstLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[userArr[0] sumMoney].doubleValue];
    self.secondLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[userArr[1] sumMoney].doubleValue];
    self.threeLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[userArr[2] sumMoney].doubleValue];
    
    self.firstNameLabel.text = [userArr[0] name];
    self.secondNameLabel.text = [userArr[1] name];
    self.thirdNameLabel.text = [userArr[2] name];
    
}

@end
