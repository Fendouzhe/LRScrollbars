//
//  IntentionProductCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "IntentionProductCell.h"
#import "IntentionProductModel.h"

@interface IntentionProductCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 图标 */
@property (nonatomic,strong) UILabel *mainLabel;/**< 标题 */
@property (nonatomic,strong) UILabel *priceLabel;/**< 价格 */
@property (nonatomic,strong) UILabel *brokerage;/**< 佣金 */
@property (nonatomic,strong) UIView *lineView;/**< 线条 */
@property (nonatomic ,strong)UILabel *postageLabel;/**< 邮费  */
@end

@implementation IntentionProductCell

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.backgroundColor = [UIColor redColor];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor redColor];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)brokerage{
    if (_brokerage == nil) {
        _brokerage = [[UILabel alloc] init];
        _brokerage.font = KDefaultFont;
        [self addSubview:_brokerage];
    }
    return _brokerage;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KGrayColorSeparatorLine;
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)postageLabel{
    if (_postageLabel == nil) {
        _postageLabel = [[UILabel alloc] init];
        _postageLabel.font = KDefaultFont;
        [self addSubview:_postageLabel];
    }
    return _postageLabel;
}

-(void)setCellData:(Product *)cellData{
    _cellData = cellData;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cellData.adImage]];
    self.mainLabel.text = cellData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"现价:￥%.2f",cellData.finalPrice.floatValue];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:2];
    self.brokerage.text = [NSString stringWithFormat:@"佣金:￥%.2f",cellData.commission.floatValue];
    if (cellData.shippingFee) {
        self.postageLabel.text = [NSString stringWithFormat:@"邮费:￥%.2f",cellData.shippingFee.floatValue];
    }else{
        self.postageLabel.text = @"免邮";
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"CustomerLevelCell";
    IntentionProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IntentionProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iconImageViewH = self.frame.size.height - 20;
    CGFloat iconImageViewW = iconImageViewH;
    CGFloat iconImageViewX = 10;
    CGFloat iconImageViewY = 10;
    self.iconImageView.frame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
    [self.mainLabel sizeToFit];
    CGFloat mainLabelX = CGRectGetMaxX(self.iconImageView.frame) + 10;
    CGFloat mainLabelY = iconImageViewY;
    CGFloat mainLabelW = self.frame.size.width - mainLabelX - 10;
    CGFloat mainLabelH = self.mainLabel.frame.size.height;
    self.mainLabel.frame = CGRectMake(mainLabelX, mainLabelY, mainLabelW, mainLabelH);
    [self.priceLabel sizeToFit];
    CGFloat priceLabelX = mainLabelX;
    CGFloat priceLabelY = iconImageViewY + iconImageViewH * 0.5;
    CGFloat priceLabelW = mainLabelW;
    CGFloat priceLabelH = self.priceLabel.frame.size.height;
    
    self.priceLabel.frame = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    [self.brokerage sizeToFit];
    CGFloat brokerageX = mainLabelX;
    CGFloat brokerageH = self.brokerage.height;
    CGFloat brokerageY = CGRectGetMaxY(self.iconImageView.frame)-brokerageH;
    CGFloat brokerageW = mainLabelW;
    
    self.brokerage.frame = CGRectMake(brokerageX, brokerageY, brokerageW, brokerageH);
    CGFloat lineViewX = mainLabelX;
    CGFloat lineViewY = CGRectGetMaxY(self.iconImageView.frame);
    CGFloat lineViewW = mainLabelW;
    CGFloat lineViewH = 0.5;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    [self.postageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}
@end
