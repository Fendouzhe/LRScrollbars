//
//  CustomerProductListHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerProductListHeaderView.h"
#import "RightImageButton.h"

@interface CustomerProductListHeaderView ()

@property (nonatomic,strong) UIButton *selectButton;/**< 选中的按钮 */
@end

@implementation CustomerProductListHeaderView

-(RightImageButton *)priceBtn{
    if (_priceBtn == nil) {
        _priceBtn = [RightImageButton buttonWithType:UIButtonTypeCustom];
//        _priceBtn.backgroundColor = [UIColor redColor];
        _priceBtn.titleLabel.font = KDefaultFont;
        [_priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_priceBtn addTarget:self action:@selector(priceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_priceBtn];
    }
    return _priceBtn;
}

-(UIButton *)productNewBtn{
    if (_productNewBtn == nil) {
        _productNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _productNewBtn.titleLabel.font = KDefaultFont;
//        _productNewBtn.backgroundColor = [UIColor redColor];
        [_productNewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_productNewBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_productNewBtn addTarget:self action:@selector(productNewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_productNewBtn];
    }
    return _productNewBtn;
}

-(UIButton *)saleBtn{
    if (_saleBtn == nil) {
        _saleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saleBtn.titleLabel.font = KDefaultFont;
//        _saleBtn.backgroundColor = [UIColor redColor];
        [_saleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_saleBtn addTarget:self action:@selector(saleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saleBtn];
        _saleBtn.selected = YES;
        self.selectButton = _saleBtn;
    }
    return _saleBtn;
}

-(RightImageButton *)brokerageBtn{
    if (_brokerageBtn == nil) {
        _brokerageBtn = [RightImageButton buttonWithType:UIButtonTypeCustom];
        _brokerageBtn.titleLabel.font = KDefaultFont;
//        _brokerageBtn.backgroundColor = [UIColor redColor];
        [_brokerageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_brokerageBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_brokerageBtn addTarget:self action:@selector(brokerageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_brokerageBtn];
    }
    return _brokerageBtn;
}

-(void)priceBtnClick{
    if ([self.delegate respondsToSelector:@selector(sequenceButtonClick:)]) {
        [self.delegate sequenceButtonClick:0];
    }
//    self.selectButton.selected = NO;
//    self.priceBtn.selected = YES;
//    self.selectButton = self.priceBtn;
    [self.brokerageBtn setTitle:self.startArray[3] forState:UIControlStateNormal];
}

-(void)productNewBtnClick{
    if ([self.delegate respondsToSelector:@selector(sequenceButtonClick:)]) {
        [self.delegate sequenceButtonClick:1];
    }
    self.selectButton.selected = NO;
    self.productNewBtn.selected = YES;
    self.selectButton = self.productNewBtn;
    [self.priceBtn setTitle:self.startArray[0] forState:UIControlStateNormal];
    [self.brokerageBtn setTitle:self.startArray[3] forState:UIControlStateNormal];
}

-(void)saleBtnClick{
    if ([self.delegate respondsToSelector:@selector(sequenceButtonClick:)]) {
        [self.delegate sequenceButtonClick:2];
    }
    self.selectButton.selected = NO;
    self.saleBtn.selected = YES;
    self.selectButton = self.saleBtn;
    [self.priceBtn setTitle:self.startArray[0] forState:UIControlStateNormal];
    [self.brokerageBtn setTitle:self.startArray[3] forState:UIControlStateNormal];
}

-(void)brokerageBtnClick{
    if ([self.delegate respondsToSelector:@selector(sequenceButtonClick:)]) {
        [self.delegate sequenceButtonClick:3];
    }
//    self.selectButton.selected = NO;
//    self.brokerageBtn.selected = YES;
//    self.selectButton = self.brokerageBtn;
    [self.priceBtn setTitle:self.startArray[0] forState:UIControlStateNormal];
}

-(void)setButtonClick:(NSInteger)number{
    switch (number) {
        case 0:
        {
            self.selectButton.selected = NO;
            self.priceBtn.selected = YES;
            self.selectButton = self.priceBtn;
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
            self.selectButton.selected = NO;
            self.brokerageBtn.selected = YES;
            self.selectButton = self.brokerageBtn;
        }
            break;
        default:
            break;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    [self.productNewBtn sizeToFit];
    [self.saleBtn sizeToFit];
    [self.priceBtn sizeToFit];
    [self.brokerageBtn sizeToFit];
//    self.priceBtn.frame = CGRectMake(0, 0, w/4, h);
//    self.productNewBtn.frame = CGRectMake(w/4, 0, w/4, h);
//    self.saleBtn.frame = CGRectMake(w/4*2, 0, w/4, h);
//    self.brokerageBtn.frame = CGRectMake(w/4*3, 0, w/4, h);
    CGFloat productNewBtnX = w*0.5 - self.productNewBtn.frame.size.width - 10;
    self.productNewBtn.frame = CGRectMake(productNewBtnX, 0, self.productNewBtn.frame.size.width, h);
    CGFloat priceBtnX = (productNewBtnX - 10 - self.priceBtn.frame.size.width)*0.5-10;
    self.priceBtn.frame = CGRectMake(priceBtnX, 0, self.priceBtn.frame.size.width+20, h);
    CGFloat saleBtnX = w*0.5 + 10;
    self.saleBtn.frame = CGRectMake(saleBtnX, 0, self.saleBtn.frame.size.width, h);
    CGFloat brokerageBtnX = w-(w - CGRectGetMaxX(self.saleBtn.frame)-self.brokerageBtn.frame.size.width-20)*0.5-10-self.brokerageBtn.frame.size.width-10;
    self.brokerageBtn.frame = CGRectMake(brokerageBtnX, 0, self.brokerageBtn.frame.size.width+20, h);
}

@end
