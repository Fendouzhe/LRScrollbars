//
//  SliderShopListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SliderShopListCell.h"
#import "SliderShopListModel.h"

@interface SliderShopListCell ()
@property (nonatomic,weak) UIImageView *titleImageView;/**< <#属性#> */
@property (nonatomic,weak) UILabel *mainLabel;/**< 标题 */
@property (nonatomic,weak) UILabel *priceNewLabel;/**< 新价格 */
@property (nonatomic,weak) UILabel *priceTailLabel;/**< 价格后面的Label */
@property (nonatomic,weak) UILabel *priceOldlabel;/**< 旧价格 */
@property (nonatomic,weak) UIButton *buyButton;/**< 购买 */
@property (nonatomic,weak) UILabel *buyPersonLabel;/**< 购买 */
@end

@implementation SliderShopListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID;
    ID = NSStringFromClass([self class]);
    SliderShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SliderShopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *titleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:titleImageView];
        self.titleImageView = titleImageView;
        
        UILabel *mainLabel = [[UILabel alloc] init];
        mainLabel.font = KDefaultFont;
        [self.contentView addSubview:mainLabel];
        self.mainLabel = mainLabel;
        
        UILabel *priceNewLabel = [[UILabel alloc] init];
        priceNewLabel.font = KDefaultFont;
        [self.contentView addSubview:priceNewLabel];
        self.priceNewLabel = priceNewLabel;
        
        UILabel *priceTailLabel = [[UILabel alloc] init];
        priceTailLabel.font = KDefaultFontSmall;
        [self.contentView addSubview:priceTailLabel];
        self.priceTailLabel = priceTailLabel;
        
        UILabel *priceOldlabel = [[UILabel alloc] init];
        priceOldlabel.font = KDefaultFontSmall;
        [self.contentView addSubview:priceOldlabel];
        self.priceOldlabel = priceOldlabel;
        
        UIButton *buyButton = [[UIButton alloc] init];
        buyButton.layer.cornerRadius = SMCornerRadios;
        buyButton.layer.masksToBounds = YES;
        buyButton.titleLabel.font = KDefaultFontSmall;
        [buyButton setTitle:@"立即抢购" forState:UIControlStateNormal];
        [buyButton setTitle:@"抢完了" forState:UIControlStateSelected];
        [self.contentView addSubview:buyButton];
        self.buyButton = buyButton;
        
        UILabel *buyPersonLabel = [[UILabel alloc] init];
        buyPersonLabel.textColor = KGrayColor;
        buyPersonLabel.font = KDefaultFontSmall;
        [self.contentView addSubview:buyPersonLabel];
        self.buyPersonLabel = buyPersonLabel;
        
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@(170*SMMatchWidth));
        }];
        
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(titleImageView.mas_bottom).with.offset(8);
        }];
        
        [priceNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainLabel);
            make.top.equalTo(mainLabel.mas_bottom).with.offset(10);
        }];
        
        [priceTailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceNewLabel.mas_right);
            make.bottom.equalTo(priceNewLabel.mas_bottom);
        }];
        
        [priceOldlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainLabel);
            make.top.equalTo(priceNewLabel.mas_bottom).with.offset(10);
        }];
        
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainLabel.mas_bottom).with.offset(5);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        
        [buyPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(buyButton);
            make.top.equalTo(buyButton.mas_bottom).with.offset(5);
        }];
    }
    return self;
}

-(void)setCellData:(SliderShopListModel *)cellData{
    _cellData = cellData;
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:cellData.imageUrl] placeholderImage:[UIImage imageNamed:@"220"]];
    self.mainLabel.text = cellData.title;
    [self.priceNewLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"￥%@",cellData.price]]];
    self.priceOldlabel.text = cellData.oldPrice;
    if (cellData.grabEnd) {
        self.buyButton.selected = YES;
        self.buyButton.backgroundColor = KGrayColor;
    }else{
        self.buyButton.selected = NO;
        self.buyButton.backgroundColor = KRedColor;
    }
    self.buyPersonLabel.text = [NSString stringWithFormat:@"已有%d在抢购",cellData.personNumber];
}

-(NSMutableAttributedString *)changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    
    [attrString addAttributes:@{NSFontAttributeName:KDefaultFontSmall,NSForegroundColorAttributeName:KRedColor} range:NSMakeRange(0,1)];
    
    NSDictionary *dic = @{NSFontAttributeName:KDefaultFontBig,NSForegroundColorAttributeName:KRedColor};
    NSRange rang = NSMakeRange(1, needText.length - 1);
    [attrString addAttributes:dic range:rang];
    
    
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:@"/人"];
    
    [attrString1 addAttributes:@{NSFontAttributeName:KDefaultFontSmall,NSForegroundColorAttributeName:KGrayColor} range:NSMakeRange(0, 2)];
    
    [attrString appendAttributedString:attrString1];
    
    return attrString;
}

@end
