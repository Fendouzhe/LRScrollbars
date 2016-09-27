//
//  CustomerProductListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerProductListCell.h"
//#import "CustomerProductListBaseModel.h"
//#import "CustomerProductListNormalModel.h"
//#import "CustomerProductListSelectModel.h"
#import "Product.h"
#import "NSString+Extension.h"

@interface CustomerProductListCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 图像 */
@property (nonatomic,strong) UILabel *textLabel;/**< 标题 */
@property (nonatomic,strong) UILabel *priceLabel;/**< 价格 */
@property (nonatomic,strong) UILabel *brokerage1;/**< 佣金1，文本佣金 */
@property (nonatomic,strong) UILabel *brokerage2;/**< 佣金2 ，佣金金额 */
@property (nonatomic,strong) UIImageView *selectImageView;/**< 选中属性图片 */
@end

@implementation CustomerProductListCell

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = SMCornerRadios;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

-(UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = KDefaultFont;
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)brokerage1{
    if (_brokerage1 == nil) {
        _brokerage1 = [[UILabel alloc] init];
        _brokerage1.font = KDefaultFont;
        [self.contentView addSubview:_brokerage1];
    }
    return _brokerage1;
}

-(UILabel *)brokerage2{
    if (_brokerage2 == nil) {
        _brokerage2 = [[UILabel alloc] init];
        _brokerage2.font = KDefaultFont;
        [self.contentView addSubview:_brokerage2];
    }
    return _brokerage2;
}

-(UIImageView *)selectImageView{
    if (_selectImageView == nil) {
        _selectImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectImageView];
    }
    return _selectImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.brokerage1.text = @"佣金";
    }
    return self;
}

-(void)setCellData:(Product *)cellData{
    _cellData = cellData;
//    if ([cellData isKindOfClass:[CustomerProductListNormalModel class]]) {
//        CustomerProductListNormalModel *data = (CustomerProductListNormalModel *)cellData;
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.iconImage]];
//        self.textLabel.text = data.title;
//        self.priceLabel.text = [NSString stringWithFormat:@"￥: %@",data.price];
//        self.brokerage2.text = [NSString stringWithFormat:@"￥: %@",data.brokerage];
//        return;
//    }
    if ([cellData isKindOfClass:[Product class]]) {
//        Product *data = (CustomerProductListSelectModel *)cellData;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cellData.adImage]];
        self.textLabel.text = cellData.name;
        self.priceLabel.text = [NSString stringWithFormat:@"￥: %@",cellData.finalPrice];
        NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
        [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [nFormat setMaximumFractionDigits:2];
        self.brokerage2.text = [NSString stringWithFormat:@"￥: %@",[nFormat stringFromNumber:cellData.commission]];
        if (cellData.isSelect) {
            //选中图片
            self.selectImageView.image = [UIImage imageNamed:@"selectImage"];
        }else{//没有选中的图片
            self.selectImageView.image = [UIImage imageNamed:@"noSelectImage"];
        }
        [self layoutSubviews];
        return;
    }
}

-(void)cellSelect{
    if ([self.cellData isKindOfClass:[Product class]]) {
        Product *data = (Product *)self.cellData;
        data.select = !data.isSelect;
        if (data.isSelect) {
            //选中图片
            self.selectImageView.image = [UIImage imageNamed:@"selectImage"];
        }else{//没有选中的图片
            self.selectImageView.image = [UIImage imageNamed:@"noSelectImage"];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iconImageViewW = self.frame.size.width;
    CGFloat iconImageViewH = iconImageViewW;
    self.iconImageView.frame = CGRectMake(0, 0, iconImageViewW, iconImageViewH);
    CGFloat titleX = 5 ;
    CGFloat titleY = CGRectGetMaxY(self.iconImageView.frame);
    CGFloat titleW = iconImageViewW - 10;
    [self.textLabel sizeToFit];
    CGFloat titleH = self.textLabel.frame.size.height;
    self.textLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    CGFloat priceLabelX = 5;
    CGFloat priceLabelY = CGRectGetMaxY(self.textLabel.frame);
    [self.priceLabel sizeToFit];
    self.priceLabel.frame = CGRectMake(priceLabelX, priceLabelY, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    
    [self.brokerage2 sizeToFit];
    CGFloat brokerage2W = self.brokerage2.frame.size.width;
    CGFloat brokerage2H = self.brokerage2.frame.size.height;
    CGFloat brokerage2X = self.frame.size.width - brokerage2W - 5;
    CGFloat brokerage2Y = CGRectGetMaxY(self.priceLabel.frame)-brokerage2H;
    self.brokerage2.frame = CGRectMake(brokerage2X, brokerage2Y, brokerage2W, brokerage2H);
    
    [self.brokerage1 sizeToFit];
    CGFloat brokerage1W = self.brokerage1.frame.size.width;
    CGFloat brokerage1H = self.brokerage1.frame.size.height;
    CGFloat brokerage1X = brokerage2X - brokerage1W - 5;
    CGFloat brokerage1Y = CGRectGetMaxY(self.priceLabel.frame)-brokerage2H;
    self.brokerage1.frame = CGRectMake(brokerage1X, brokerage1Y, brokerage1W, brokerage1H);
    
//    self.selectImageView.frame = CGRectMake(10, 5, 20, 20);
    
//    if ([self.cellData isKindOfClass:[CustomerProductListNormalModel class]]) {
//        _selectImageView.hidden = YES;
//        return;
//    }
    if ([self.cellData isKindOfClass:[Product class]]) {
        self.selectImageView.frame = CGRectMake(10, 5, 20, 20);
        self.selectImageView.hidden = NO;
    }
}

@end
