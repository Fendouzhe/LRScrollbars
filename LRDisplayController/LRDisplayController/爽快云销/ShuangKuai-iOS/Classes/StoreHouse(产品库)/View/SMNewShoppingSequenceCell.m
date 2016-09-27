//
//  SMNewShoppingSequenceCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewShoppingSequenceCell.h"

@interface SMNewShoppingSequenceCell ()


@property (weak, nonatomic) IBOutlet UIButton *classesBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNewW;

@property (weak, nonatomic) IBOutlet UIView *grayLine;



@end

@implementation SMNewShoppingSequenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.classesBtn.titleLabel.font = KDefaultFontMiddleMatch;
    self.priceBtn.titleLabel.font = KDefaultFontMiddleMatch;
    self.salesCountBtn.titleLabel.font = KDefaultFontMiddleMatch;
    self.commisionBtn.titleLabel.font = KDefaultFontMiddleMatch;
    self.productNew.titleLabel.font = KDefaultFontMiddleMatch;
    
    [self.priceBtn setTitleColor:KRedColorLight forState:UIControlStateSelected];
    [self.salesCountBtn setTitleColor:KRedColorLight forState:UIControlStateSelected];
    [self.commisionBtn setTitleColor:KRedColorLight forState:UIControlStateSelected];
    [self.productNew setTitleColor:KRedColorLight forState:UIControlStateSelected];
    
    self.salesCountBtn.selected = YES;
//    self.productNew.selected = YES;
    
    self.classWidth.constant = 50 *SMMatchWidth;
    self.productNewW.constant = 40 *SMMatchWidth;
    
    
    self.grayLine.backgroundColor = KControllerBackGroundColor;
    
//    UIImage *image1 = self.priceBtn.imageView.image;
//    [self.priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image1.size.width, 0, image1.size.width)];
//    [self.priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.priceBtn.titleLabel.bounds.size.width, 0, -self.priceBtn.titleLabel.bounds.size.width)];
//    
//    UIImage *image2 = self.commisionBtn.imageView.image;
//    [self.commisionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image2.size.width, 0, image2.size.width)];
//    [self.commisionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.commisionBtn.titleLabel.bounds.size.width, 0, -self.commisionBtn.titleLabel.bounds.size.width)];
}

#pragma mark -- 点击事件

- (IBAction)productNewClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(productNewDidClick:)]) {
        [self.delegate productNewDidClick:sender];
    }
}

- (IBAction)priceClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(priceDidClick:)]) {
        [self.delegate priceDidClick:sender];
    }
}

- (IBAction)salesCountClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(salesCountDidClick:)]) {
        [self.delegate salesCountDidClick:sender];
    }
}

- (IBAction)commisionClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commisionDidClick:)]) {
        [self.delegate commisionDidClick:sender];
    }
}

- (IBAction)classesClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(classesDidClick)]) {
        [self.delegate classesDidClick];
    }
}

@end
