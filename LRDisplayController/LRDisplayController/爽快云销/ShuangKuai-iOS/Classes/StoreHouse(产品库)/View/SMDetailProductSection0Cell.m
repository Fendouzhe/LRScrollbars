//
//  SMDetailProductSection0Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductSection0Cell.h"

@implementation SMDetailProductSection0Cell

+ (instancetype)detailProductSection0View{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDetailProductSection0Cell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"detailProductSection0Cell";
    SMDetailProductSection0Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMDetailProductSection0Cell detailProductSection0View];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    //字体加中划线
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"邮费：￥0" attributes:dict];
    [self.originalLabel setAttributedText:attributeStr];
    
    self.currentLabel.textColor = KRedColorLight;
    self.commissionLabel.textColor = KRedColorLight;
    
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(Product *)product{
    _product = product;
    
    
    self.nameLabel.text = product.name;
    
    
    SMLog(@"self.specPrice setProduct  %@  self.specPrice2  %@",self.specPrice,self.specPrice2);
    
    if (self.specPrice && ![self.specPrice isEqualToString:@""]) {
        self.currentLabel.text = self.specPrice;
    }else if (self.specPrice2 && ![self.specPrice2 isEqualToString:@""]){
        self.currentLabel.text = self.specPrice2;
    }else{
        self.currentLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.finalPrice doubleValue]];
    }
    
    
//    [self.originalLabel setAttributedText:[self originalpricelable:product.price]];
    NSString *originalPrice = [NSString stringWithFormat:@"原价:%.2f",product.price.floatValue];
    [self.originalLabel setAttributedText:[self lineWithString:originalPrice]];
    
    
    self.commissionLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.commission doubleValue]];
    
    
    self.postageLabel.text = [NSString stringWithFormat:@"邮费:%.2f元",product.shippingFee.doubleValue];
    
    self.monthlySalesLabel.text = [NSString stringWithFormat:@"销售量：%zd",product.sales];
    
    if (product.stock < 0) {
        product.stock = 0;
    }
    self.stockLabel.text = [NSString stringWithFormat:@"库存：%zd",product.stock];
}

-(NSAttributedString *)lineWithString:(NSString *)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string] attributes:dict];
    return attributeStr;
}

//原价中划横线
-(NSAttributedString*)originalpricelable:(NSNumber *)price
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
   NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价¥%.2f",price.doubleValue] attributes:dict];
    return attributeStr;
}


@end
